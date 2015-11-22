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
          course_log: { $set: data.course_log }
        }), function(){
          this.refs.pad.clear();
        }.bind(this));
      }.bind(this)
    });
  },

  removeStudent: function(student) {
    $.ajax({
      method: "DELETE",
      url: "/room/course_log/" + this.state.course_log.id + "/students",
      data: { card_code: student.card_code },
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

  _loadSearchStudentResult: function(result) {
    this.setState(React.addons.update(this.state, {
      student: { $set: result.student },
      not_found_alert: { $set: result.student == null },
      show_students: { $set: false },
    }));
  },

  render: function() {
    var rightPanel = null;

    if (this.state.show_students) {
      rightPanel = (<div>
        <ul>
        {this.state.course_log.students.map(function(student){
            return (<li key={student.card_code}>
              {student.first_name} {student.last_name}
              &nbsp;
              <button className="btn btn-danger" onClick={function(){this.removeStudent(student)}.bind(this)}>
                <i className="glyphicon glyphicon-trash"/> Eliminar
              </button>
            </li>);
        }.bind(this))}
        </ul>
      </div>);
    } else if (this.state.student) {
      rightPanel = (<div>
        <h1>{this.state.student.first_name}</h1>
        <h1>{this.state.student.last_name}</h1>
        <h1>{this.state.student.email}</h1>
        <h1>{this.state.student.card_code}</h1>
        <hr/>
        <button className="btn btn-lg btn-primary" onClick={this.addStudent}>
          <i className="glyphicon glyphicon-ok"/> Presente
        </button>
        <button className="btn btn-lg btn-default" onClick={this.refs.pad.clear}>
          Cancelar
        </button>
      </div>);
    } else if (this.state.not_found_alert) {
      rightPanel = (<div>
        <h1>Alumno no encontrado</h1>
      </div>);
    }

    return (
    <div>
      <div className="row">
        <div>
          {this.state.course_log.teachers.join(" - ")}
        </div>
        <button className="btn btn-lg" onClick={this.toggleStudents}>
          {this.state.course_log.total_students} Alumno(s)
        </button>
      </div>
      <div className="row">
        <div className="col-md-6">
          <StudentPad ref="pad" onChange={this.onStudentChange}/>
        </div>
        <div className="col-md-6">
          {rightPanel}
        </div>
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
    return (<div>
      <table style={{width: 100 + '%', height: 100 + '%'}}>
        <tbody>
          <tr>
            <td colSpan="3" style={{textAlign: 'center'}}>
              <h1>
                <span style={{color: '#ccc'}}>SWC/stu/</span>
                <div style={{width: 4 + 'em', display: 'inline-block', textAlign: 'left'}}>
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
            <StudentPadButton digit="x" onClick={this.clear} />
          </tr>
        </tbody>
      </table>
    </div>
    );
  }
});

var StudentPadButton = React.createClass({
  click: function() {
    this.props.onClick(this.props.digit);
  },

  render: function() {
    if (this.props.digit == "") {
      return <td><button>&nbsp;</button></td>;
    }

    return (
      <td>
        <button onClick={this.click}>{this.props.digit}</button>
      </td>
    );
  }
});
