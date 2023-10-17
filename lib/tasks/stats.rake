def to_csv(query, file)
  result = ActiveRecord::Base.connection.execute(query)

  CSV.open(file, 'wb') do |csv|
    csv << result.fields
    result.each do |r|
      csv << r
    end
  end
end

namespace :app do
  desc 'Restore mysql backup'
  task stats: :environment do |_t, _args|
    # Which months a student went to a class
    # month encoded as integers YYYYMM
    #
    # | student_id | month |
    student_months = StudentCourseLog.joins(:course_log) \
      .select('DISTINCT student_id, YEAR(course_logs.date) * 100 + MONTH(course_logs.date) as month') \
      .to_sql

    # First and last month (YYYYMM) of each student
    # month_span measures the life of the student (from first to last)
    # if first_month == last_month then month_span == 1
    #
    # | student_id | first_month | last_month | month_span
    first_last_month = %(
      SELECT student_id, first_month, last_month,
        ((last_month DIV 100) * 12 + (last_month MOD 12)) - ((first_month DIV 100) * 12 + (first_month MOD 12)) + 1 as month_span
      FROM (
        SELECT student_id, MIN(month) as first_month, MAX(month) as last_month
        FROM (#{student_months}) as student_months
        GROUP BY student_id) as flm
    )

    # Flow of a student across a month.
    # It measures the following month of a student given a current_month.
    # The student didn't go to a class between current_month and next_month
    #
    # student_id | current_month | next_month
    current_next_month = %(
      SELECT c.student_id, c.month as current_month, MIN(n.month) as next_month
    FROM (#{student_months}) as c
    INNER JOIN (#{student_months}) as n
      ON c.student_id = n.student_id
      AND c.month < n.month
    GROUP BY c.student_id, c.month)

    # How many students take the first class on a given month
    #
    # month | students
    first_month = %(
      SELECT m.first_month as month, count(*) as students
      FROM (#{first_last_month}) as m
      GROUP BY m.first_month
      ORDER BY m.first_month
    )

    # How many students take the last class on a given month
    #
    # month | students
    last_month = %(
      SELECT m.last_month as month, count(*) as students
      FROM (#{first_last_month}) as m
      GROUP BY m.last_month
      ORDER BY m.last_month
    )

    # How many students that that went on current_month
    # went to the next class on next_month
    #
    # current_month | next_month | students
    month_flow = %(
      SELECT current_month, next_month, count(*) as students
      FROM (#{current_next_month}) as m
      GROUP BY current_month, next_month
      ORDER BY current_month, next_month
    )

    # How many students started and finished their activity
    # in specific months. They may have not come all the months
    # in between
    #
    # first_month | last_month | students
    month_survival = %(
      SELECT first_month, last_month, count(*) as students
      FROM (#{first_last_month}) as m
      GROUP BY first_month, last_month
      ORDER BY first_month, last_month
    )

    # How many months a specific student went to classes
    #
    # student_id | months_count
    student_months_count = %(
      SELECT student_id, count(*) as months_count
      FROM (#{student_months}) as m
      GROUP BY student_id
    )

    this_month = (School.today.year * 100) + School.today.month

    # How is the engagement of the student towards the school.
    # Combines the lifespan of the student (first_month, last_month, month_span)
    # and performs a ratio of how many months did he/she had activity (months_count).
    #
    # student_id | months_count | first_month | last_month | month_span | engagement
    engagement = %(
      SELECT
        sm.student_id, sm.months_count,
        flm.first_month, flm.last_month, flm.month_span,
        (sm.months_count / flm.month_span) as engagement
      FROM (#{student_months_count}) as sm
      INNER JOIN (#{first_last_month}) as flm
      ON sm.student_id = flm.student_id
      WHERE flm.last_month = #{this_month}
      ORDER BY flm.first_month
    )

    FileUtils.mkdir_p './stats'
    to_csv first_month, './stats/first_month.csv'
    to_csv last_month, './stats/last_month.csv'
    to_csv month_flow, './stats/month_flow.csv'
    to_csv month_survival, './stats/month_survival.csv'
    to_csv engagement, './stats/engagement.csv'
  end
end
