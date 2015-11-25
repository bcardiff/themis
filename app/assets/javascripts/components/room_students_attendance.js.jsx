var RoomStudentsAttendance = React.createClass({
  getInitialState: function(){
    return {
      student: null,
      not_found_alert: false,
      course_log: this.props.course_log,
      show_students: false,
    }
  },

  onStudentChange: function(card_code) {
    if (card_code == "") {
      this.setState(React.addons.update(this.state, {
        student: { $set: null },
        not_found_alert: { $set: false },
        show_students: { $set: false },
      }));
      return;
    }

    $.ajax({
      url: "/room/course_log/" + this.state.course_log.id + "/students/search",
      data: { q: card_code },
      success: function(data) {
        this._loadSearchStudentResult(data)
      }.bind(this)
    });
  },

  addStudent: function() {
    $.ajax({
      method: "POST",
      url: "/room/course_log/" + this.state.course_log.id + "/students",
      data: { card_code: this.state.student.card_code },
      success: function(data) {
        this.setState(React.addons.update(this.state, {
          course_log: { $set: data.course_log },
          student: { $set: null }
        }), function(){
          this.refs.pad.clear();
        }.bind(this));
      }.bind(this)
    });
  },

  removeStudent: function() {
    $.ajax({
      method: "DELETE",
      url: "/room/course_log/" + this.state.course_log.id + "/students",
      data: { card_code: this.state.student.card_code },
      success: function(data) {
        this.setState(React.addons.update(this.state, {
          course_log: { $set: data.course_log }
        }));
      }.bind(this)
    });
  },

  toggleStudents: function() {
    this.setState(React.addons.update(this.state, {
      show_students: { $set: !this.state.show_students },
    }));
  },

  _loadExistingStudent: function(student) {
    this.setState(React.addons.update(this.state, {
      student: { $set: student },
      not_found_alert: { $set: false },
      show_students: { $set: false },
      back_to_show_students: { $set: true },
    }));
  },

  _loadSearchStudentResult: function(result) {
    this.setState(React.addons.update(this.state, {
      student: { $set: result.student },
      not_found_alert: { $set: result.student == null },
      show_students: { $set: false },
      back_to_show_students: { $set: false },
    }));
  },

  _clearCurrentStudent: function() {
    if (!this.state.back_to_show_students) {
      this.refs.pad.clear();
    } else {
      this.setState(React.addons.update(this.state, {
        show_students: { $set: true }
      }));
    }
  },

  containsStudent: function(student) {
    return _.filter(this.state.course_log.students, _.matches({card_code: student.card_code})).length > 0;
  },

  render: function() {
    var rightPanel = null;

    if (this.state.show_students) {
      rightPanel = (<div className="students-list">
        <div className="btn-group">
        {this.state.course_log.students.map(function(student){
            return (
              <button key={student.card_code} className="btn btn-lg btn-light" onClick={function(){ this._loadExistingStudent(student); }.bind(this)}>
                {student.first_name}
                &nbsp;
                {student.last_name}
              </button>);
        }.bind(this))}
        </div>
      </div>);
    } else if (this.state.student) {
      var studentAction;
      if (!this.containsStudent(this.state.student)) {
        studentAction = (<button className="btn btn-lg btn-positive" onClick={this.addStudent}>
          <i className="glyphicon glyphicon-thumbs-up"/> Dar Presente
        </button>);
      } else {
        studentAction = (<button className="btn btn-lg btn-negative" onClick={this.removeStudent}>
          <i className="glyphicon glyphicon-thumbs-down"/> Quitar Presente
        </button>);
      }

      rightPanel = (<div>
        <h1>{this.state.student.first_name}</h1>
        <h1>{this.state.student.last_name}</h1>
        <h1>{this.state.student.email}</h1>
        <h1>{this.state.student.card_code}</h1>
        <div className="layout-columns student-actions">
          {studentAction}
          <button className="btn btn-lg btn-light" onClick={this._clearCurrentStudent}>
            Cancelar
          </button>
        </div>
      </div>);
    } else if (this.state.not_found_alert) {
      rightPanel = (<div>
        <h1>Alumno no encontrado</h1>
      </div>);
    }

    return (
    <div className="layout-columns">
      <div>
        <StudentPad ref="pad" onChange={this.onStudentChange}/>
        <button id="toggleStudents" className={"btn btn-light " + (this.state.show_students ? "active" : "")} onClick={this.toggleStudents}>
          Total:
          <b>{this.state.course_log.total_students}</b>
          Alumno{this.state.course_log.total_students != 1 ? 's' : null}
        </button>
      </div>
      <div>
        {rightPanel}
      </div>
    </div>);
  }
});

var StudentPad = React.createClass({

  getInitialState: function(){
    return { card_code: "" }
  },

  // debounce: http://stackoverflow.com/a/24679479/30948
  componentWillMount: function() {
    this.fireChangeDebounced = _.debounce(function(){
      this._fireChange.apply(this, [this.state.card_code]);
    }, 500);
  },

  _performUserInput: function(new_card_code) {
    this.setState(React.addons.update(this.state, {
      card_code: { $set: new_card_code }
    }));
    this.fireChangeDebounced();
  },

  _fireChange: function(card_code) {
    this.props.onChange(card_code);
  },

  appendDigit: function(digit) {
    this._performUserInput(this.state.card_code + digit);
  },

  clear: function() {
    this._performUserInput("");
  },

  render: function() {
    return (
      <table className="studentpad">
        <tbody>
          <tr>
            <td colSpan="3" style={{textAlign: 'center'}}>
              <h1>
                <span style={{color: '#ccc'}}>SWC/stu/</span>
                <div style={{width: 3 + 'em', display: 'inline-block', textAlign: 'left'}}>
                  {this.state.card_code}<span className="blink">_</span>
                </div>
              </h1>
            </td>
          </tr>
          <tr>
            <StudentPadButton digit="1" onClick={this.appendDigit}/>
            <StudentPadButton digit="2" onClick={this.appendDigit}/>
            <StudentPadButton digit="3" onClick={this.appendDigit}/>
          </tr>
          <tr>
            <StudentPadButton digit="4" onClick={this.appendDigit}/>
            <StudentPadButton digit="5" onClick={this.appendDigit}/>
            <StudentPadButton digit="6" onClick={this.appendDigit}/>
          </tr>
          <tr>
            <StudentPadButton digit="7" onClick={this.appendDigit}/>
            <StudentPadButton digit="8" onClick={this.appendDigit}/>
            <StudentPadButton digit="9" onClick={this.appendDigit}/>
          </tr>
          <tr>
            <StudentPadButton digit="" />
            <StudentPadButton digit="0" onClick={this.appendDigit}/>
            <StudentPadButton onClick={this.clear}>
              <small>
                <i className="glyphicon glyphicon-remove-sign"/>
              </small>
            </StudentPadButton>
          </tr>
        </tbody>
      </table>
    );
  }
});

var StudentPadButton = React.createClass({
  click: function() {
    this.props.onClick(this.props.digit);
  },

  render: function() {
    if (this.props.digit == "") {
      return <td><button className="btn btn-default">&nbsp;</button></td>;
    }

    return (
      <td>
        <button onClick={this.click} className="btn btn-default">{this.props.children || this.props.digit}</button>
      </td>
    );
  }
});
