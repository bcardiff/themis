var CashierCourseDetails = React.createClass({
  getInitialState: function () {
    return {
      course_log: { description: null, students: [] },
      top_students: [], // reverse order
    };
  },

  componentWillMount: function () {
    this._updateCourseLogStatus();
  },

  componentWillReceiveProps: function (nextProps) {
    window.setTimeout(function () {
      this._updateCourseLogStatus();
    }.bind(this), 0);
  },

  _updateCourseLogStatus: function () {
    $.ajax({
      url: URI('/cashier/students/course').query({ course: this.props.course, date: this.props.config.date }),
      method: 'GET',
      success: function (data) {
        // keep students identified in this session in a different list in order
        var new_top_students = [];
        _.each(this.state.top_students, function (old_student) {
          var index = _.findIndex(data.students, 'id', old_student.id);
          new_top_students.push(_.pullAt(data.students, index)[0]);
        });

        this.setState(React.addons.update(this.state, {
          course_log: { $set: data },
          top_students: { $set: new_top_students },
        }));

      }.bind(this)
    });
  },

  trackStudent: function (student) {
    this.setState(React.addons.update(this.state, {
      top_students: { $push: [student] },
      course_log: { untracked_students_count: { $set: this.state.course_log.untracked_students_count - 1 } }
    }), function () {

      $.ajax({
        url: '/cashier/students/' + student.id + '/track_in_course_log',
        data: { course_log_id: this.state.course_log.course_log_id, untracked: true },
        method: 'POST',
        success: function (data) {
          this._updateCourseLogStatus();
        }.bind(this)
      });

    }.bind(this));
  },

  _addUntrackedStudent: function () {
    $.ajax({
      url: '/room/course_log/' + this.state.course_log.course_log_id + '/students_no_card',
      data: {},
      method: 'POST',
      success: function (data) {
        this._updateCourseLogStatus();
      }.bind(this)
    });
  },

  _addTrackedStudent: function (student) {
    $.ajax({
      url: '/room/course_log/' + this.state.course_log.course_log_id + '/students',
      data: { student_id: student.id },
      method: 'POST',
      success: function (data) {
        this._updateCourseLogStatus();
      }.bind(this)
    });
  },

  removeStudent: function (student) {
    $.ajax({
      method: "DELETE",
      url: "/room/course_log/" + this.state.course_log.course_log_id + "/students",
      data: { student_id: student.id },
      success: function (data) {
        this._updateCourseLogStatus();
      }.bind(this)
    });
  },

  removeStudentWithoutCard: function () {
    $.ajax({
      method: "DELETE",
      url: "/room/course_log/" + this.state.course_log.course_log_id + "/students_no_card",
      data: {},
      success: function (data) {
        this._updateCourseLogStatus();
      }.bind(this)
    });
  },

  render: function () {
    var course_log = this.state.course_log;
    var untracked_students = this.state.untracked_students;

    var addUntrackedStudentAttendance = function () { this._addUntrackedStudent(); }.bind(this);
    var addStudentAttendance = function (student) { this._addTrackedStudent(student); }.bind(this);

    return (
      <div>
        <h1>{course_log.description}</h1>

        <ConfirmDialog ref="dialog" />

        {this.state.top_students.map(function (student) {
          var confirmRemoveStudent = function () {
            this.refs.dialog.confirm("¿Desea quitar el presente de " + student.first_name + " " + student.last_name + "?").then(function () {
              this.removeStudent(student);
            }.bind(this));
          }.bind(this);

          return <StudentRecord key={student.id} student={student} config={this.props.config} onRemoveStudent={confirmRemoveStudent} />;
        }.bind(this))}

        {_.times(course_log.untracked_students_count, function (i) {
          var trackStudent = function (student) {
            this.trackStudent(student);
          }.bind(this);
          var confirmRemoveStudentWithoutCard = function () {
            this.refs.dialog.confirm("¿Desea quitar el presente de un alumno sin tarjeta?").then(function () {
              this.removeStudentWithoutCard();
            }.bind(this));
          }.bind(this);
          return <UntrackedStudentRecord key={i} course_log_id={course_log.course_log_id} config={this.props.config} onStudentIdentified={trackStudent} onRemoveStudentWithoutCard={confirmRemoveStudentWithoutCard} />
        }.bind(this))}

        {course_log.students.map(function (student) {
          var confirmRemoveStudent = function () {
            this.refs.dialog.confirm("¿Desea quitar el presente de " + student.first_name + " " + student.last_name + "?").then(function () {
              this.removeStudent(student);
            }.bind(this));
          }.bind(this);

          return <StudentRecord key={student.id} student={student} config={this.props.config} onRemoveStudent={confirmRemoveStudent} />;
        }.bind(this))}

        <AddStudentAttendance config={this.props.config} onAddStudentAttendance={addStudentAttendance} onAddUntrackedStudentAttendance={addUntrackedStudentAttendance} />
      </div>
    );
  }
});

var AddStudentAttendance = React.createClass({
  getInitialState: function () {
    return { show_search: false };
  },

  studentChosen: function (student) {
    this.props.onAddStudentAttendance(student);
    this.toggleSearch(); // force clear search
  },

  toggleSearch: function () {
    this.setState(React.addons.update(this.state, {
      show_search: { $set: !this.state.show_search },
    }));
  },

  render: function () {
    return (
      <div>
        <hr />
        <div className="btn-group">
          <button onClick={this.toggleSearch} className={classNames("btn btn-primary", { "active": this.state.show_search })}>Agregar asistencia</button>
          <button onClick={this.props.onAddUntrackedStudentAttendance} className="btn btn-default">Agregar asistencia sin identificar</button>
        </div>
        <br />
        <br />

        {(function () {
          if (this.state.show_search) {
            return (
              <StudentSearch config={this.props.config} onStudentChosen={this.studentChosen} />
            )
          }
        }.bind(this))()}
      </div>
    )
  }
});

var UntrackedStudentRecord = React.createClass({
  getInitialState: function () {
    return { show_search: false };
  },

  studentChosen: function (student) {
    this.props.onStudentIdentified(student);
    this.toggleSearch(); // force clear search
  },

  toggleSearch: function () {
    this.setState(React.addons.update(this.state, {
      show_search: { $set: !this.state.show_search },
    }));
  },

  render: function () {
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
            <button onClick={this.toggleSearch} className={classNames("btn btn-default", { "active": this.state.show_search })}>Identificar</button>
            &nbsp;
            <button onClick={this.props.onRemoveStudentWithoutCard} className={"btn btn-danger"}>Quitar</button>
          </div>
        </div>
        {(function () {
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
