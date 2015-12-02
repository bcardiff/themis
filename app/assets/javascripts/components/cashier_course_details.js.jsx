var CashierCourseDetails = React.createClass({
  getInitialState: function() {
    return {
      course_log: {room_name: null, students: []},
      top_students: [], // reverse order
    };
  },

  componentWillMount: function() {
    this._updateCourseLogStatus();
  },

  _updateCourseLogStatus: function() {
    $.ajax({
      url: URI('/cashier/students/course').query({course: this.props.course}),
      method: 'GET',
      success: function(data) {
        // keep students identified in this session in a different list in order
        var new_top_students = [];
        _.each(this.state.top_students, function(old_student){
          var index = _.findIndex(data.students, 'id', old_student.id);
          new_top_students.push(_.pullAt(data.students, index)[0]);
        });

        this.setState(React.addons.update(this.state, {
          course_log : { $set : data },
          top_students : { $set : new_top_students },
        }));

      }.bind(this)
    });
  },

  trackStudent: function(student) {
    this.setState(React.addons.update(this.state, {
      top_students : { $push : [student] },
      course_log : { untracked_students_count: { $set: this.state.course_log.untracked_students_count - 1 } }
    }), function() {

      $.ajax({
        url: '/cashier/students/' + student.id + '/track_in_course_log',
        data: {course_log_id: this.state.course_log.course_log_id, untracked: true},
        method: 'POST',
        success: function(data) {
          this._updateCourseLogStatus();
        }.bind(this)
      });

    }.bind(this));
  },

  render: function() {
    var course_log = this.state.course_log;
    var untracked_students = this.state.untracked_students;

    return (
      <div>
        <h1>{course_log.room_name}</h1>

        {this.state.top_students.map(function(student){
          return <StudentRecord key={student.id} student={student} config={this.props.config} />;
        }.bind(this))}

        {_.times(course_log.untracked_students_count, function(i){
          var trackStudent = function(student){
            this.trackStudent(student);
          }.bind(this);
          return <UntrackedStudentRecord key={i} course_log_id={course_log.course_log_id} config={this.props.config} onStudentIdentified={trackStudent} />
        }.bind(this))}

        {course_log.students.map(function(student){
          return <StudentRecord key={student.id} student={student} config={this.props.config} />;
        }.bind(this))}
      </div>
    );
  }
});

var UntrackedStudentRecord = React.createClass({
  getInitialState: function() {
    return { show_search: false };
  },

  studentChosen: function(student) {
    this.props.onStudentIdentified(student);
    this.toggleSearch(); // force clear search
  },

  toggleSearch: function() {
    this.setState(React.addons.update(this.state, {
      show_search : { $set : !this.state.show_search },
    }));
  },

  render: function() {
    return (
      <div>
        <hr />
        <div className="row">
          <div className="col-md-4">
            <h4>
              Alumno desconocido
            </h4>

          </div>
          <div className="col-md-4">
            <button onClick={this.toggleSearch} className={classNames("btn btn-default", {"active": this.state.show_search})}>Identificar</button>
          </div>
        </div>
        {(function(){
          if (this.state.show_search) {
            return (
            <div className="row">
              <div className="col-md-10 col-md-offset-1">
                <StudentSearch config={this.props.config} onStudentChosen={this.studentChosen} />
              </div>
            </div>);
          }
        }.bind(this))()}
      </div>
    );
  }
});