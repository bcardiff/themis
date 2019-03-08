var RoomStudentsAttendance = React.createClass({
  getInitialState: function () {
    return {
      student: null,
      not_found_alert: false,
      course_log: this.props.course_log,
      show_students: false,
      show_visitors_notice: false,
      allow_visitors: true,
      as_helper: false,
    }
  },

  onStudentChange: function (card_code) {
    if (card_code == "") {
      this.setState(React.addons.update(this.state, {
        student: { $set: null },
        not_found_alert: { $set: false },
        show_students: { $set: false },
        allow_visitors: { $set: true },
        as_helper: { $set: false },
      }));
      return;
    }

    this.setState(React.addons.update(this.state, {
      allow_visitors: { $set: false }
    }));

    if (card_code.length >= 4) {
      $.ajax({
        url: "/room/course_log/" + this.state.course_log.id + "/students/search",
        data: { q: card_code },
        success: function (data) {
          this._loadSearchStudentResult(data)
        }.bind(this)
      });
    }
  },

  onToggleHelper: function () {
    this.setState(React.addons.update(this.state, {
      as_helper: { $set: !this.state.as_helper },
    }))
  },

  _post: function (options) {
    $.ajax({
      method: "POST",
      url: options.url,
      data: options.data,
      success: function (data) {
        this.setState(React.addons.update(this.state, {
          course_log: { $set: data.course_log },
          student: { $set: null },
          as_helper: { $set: false },
        }), options.success);
      }.bind(this)
    });
  },

  _delete: function (options) {
    $.ajax({
      method: "DELETE",
      url: options.url,
      data: options.data,
      success: function (data) {
        this.setState(React.addons.update(this.state, {
          course_log: { $set: data.course_log }
        }));
      }.bind(this)
    });
  },

  addStudent: function () {
    this._post({
      url: "/room/course_log/" + this.state.course_log.id + "/students",
      data: {
        card_code: this.state.student.card_code,
        as_helper: this.state.as_helper
      },
      success: function () {
        this.refs.pad.clear();
      }.bind(this)
    });
  },

  removeStudent: function () {
    this._delete({
      url: "/room/course_log/" + this.state.course_log.id + "/students",
      data: { card_code: this.state.student.card_code },
    });
  },

  addStudentWithoutCardQuick: function () {
    this.addStudentWithoutCard(true);
  },

  addStudentWithoutCard: function (skip_notice) {
    if (!this.state.allow_visitors) {
      return;
    }

    this._post({
      url: "/room/course_log/" + this.state.course_log.id + "/students_no_card",
      data: {},
      success: function () {
        if (skip_notice != true) {
          this.setState(React.addons.update(this.state, {
            show_visitors_notice: { $set: true },
            allow_visitors: { $set: false }
          }));
        }
      }.bind(this)
    });
  },

  hideVisitorsNotice: function () {
    this.setState(React.addons.update(this.state, {
      show_visitors_notice: { $set: false },
      allow_visitors: { $set: true }
    }));
  },

  removeStudentWithoutCard: function () {
    this._delete({
      url: "/room/course_log/" + this.state.course_log.id + "/students_no_card",
      data: {},
    });
  },

  toggleStudents: function () {
    this.setState(React.addons.update(this.state, {
      show_students: { $set: !this.state.show_students },
      show_visitors_notice: { $set: false }
    }));
  },

  _loadExistingStudent: function (student) {
    this.setState(React.addons.update(this.state, {
      student: { $set: student },
      not_found_alert: { $set: false },
      show_students: { $set: false },
      back_to_show_students: { $set: true },
    }));
  },

  _loadSearchStudentResult: function (result) {
    this.setState(React.addons.update(this.state, {
      student: { $set: result.student },
      not_found_alert: { $set: result.student == null },
      show_students: { $set: false },
      back_to_show_students: { $set: false },
    }));
  },

  _clearCurrentStudent: function () {
    if (!this.state.back_to_show_students) {
      this.refs.pad.clear();
    } else {
      this.setState(React.addons.update(this.state, {
        show_students: { $set: true }
      }));
    }
  },

  containsStudent: function (student) {
    return _.filter(this.state.course_log.students, _.matches({ card_code: student.card_code })).length > 0;
  },

  render: function () {
    var rightPanel = null;


    if (this.state.show_visitors_notice) {
      rightPanel = (<div>
        <h1>¡Anotado!</h1>
        <h1>No olvides pasar por recepción a la salida</h1>

        <button className="btn btn-lg btn-positive students-list-bottom-btn" onClick={this.hideVisitorsNotice}>
          <i className="glyphicon glyphicon-thumbs-up" /> Ok, Listo
        </button>
      </div>);
    } else if (this.state.show_students) {
      rightPanel = (<div className="students-list">
        <div className="btn-group">
          {this.state.course_log.students.map(function (student) {
            return (
              <button key={student.card_code} className={"btn btn-lg " + (student.pending_payment == true ? "btn-negative" : "btn-light")} onClick={function () { this._loadExistingStudent(student); }.bind(this)}>
                {student.first_name}
                &nbsp;
                {student.last_name}
                &nbsp;
                {student.as_helper ? <i className="glyphicon glyphicon-education" /> : null}
              </button>);
          }.bind(this))}
        </div>
        <hr />
        <h2 className="text-right">
          {this.state.course_log.untracked_students_count} Alumno{this.state.course_log.untracked_students_count != 1 ? 's' : null} sin tarjeta
          <div>
            <button className="btn btn-lg btn-light" onClick={this.removeStudentWithoutCard}>
              <i className="glyphicon glyphicon-minus" />
            </button>

            <button className="btn btn-lg btn-light" onClick={this.addStudentWithoutCardQuick}>
              <i className="glyphicon glyphicon-plus" />
            </button>
          </div>
        </h2>
      </div>);
    } else if (this.state.student) {
      var studentAction, paymentWarning, studentHelper;

      if (!this.containsStudent(this.state.student)) {
        studentAction = (<button className="btn btn-lg btn-positive" onClick={this.addStudent}>
          <i className="glyphicon glyphicon-thumbs-up" /> Dar Presente
        </button>);
      } else {
        studentAction = (<button className="btn btn-lg btn-negative" onClick={this.removeStudent}>
          <i className="glyphicon glyphicon-thumbs-down" /> Quitar Presente
        </button>);
      }

      if (this.state.student.pending_payment) {
        paymentWarning = (<h1 className="negative">
          <i className="glyphicon glyphicon-exclamation-sign" /> Pasar por recepción a la salida
        </h1>);
      }

      if (this.state.as_helper) {
        studentHelper = (<h1 className="color-education">
          <i className="glyphicon glyphicon-education" /> Clase como ayudante
        </h1>);
      }

      rightPanel = (<div>
        <h1>{this.state.student.first_name}</h1>
        <h1>{this.state.student.last_name}</h1>
        <h2>{this.state.student.email}</h2>
        <h2>{this.state.student.card_code}</h2>
        {paymentWarning}
        {studentHelper}
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
          <StudentPad ref="pad" digitsClassName={this.state.as_helper ? "bg-education" : ""} onChange={this.onStudentChange} onToggleHelper={this.onToggleHelper} />
          {(function () {
            if (this.state.as_helper) {
              return (<span className={"btn btn-link students-list-bottom-btn color-education"}>estoy de ayudante</span>)
            } else {
              return (<button className={"btn btn-negative students-list-bottom-btn " + (this.state.allow_visitors && !this.state.as_helper ? "" : "disabled")} onClick={this.addStudentWithoutCard}>
                <i className="glyphicon glyphicon-barcode" /> No tengo tarjeta
            </button>);
            }
          }.bind(this))()}
          <button className={"btn btn-light students-list-bottom-btn " + (this.state.show_students ? "active " : "")} onClick={this.toggleStudents}>
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

  getInitialState: function () {
    return { card_code: "" }
  },

  // debounce: http://stackoverflow.com/a/24679479/30948
  componentWillMount: function () {
    this.fireChangeDebounced = _.debounce(function () {
      this._fireChange.apply(this, [this.state.card_code]);
    }, 500);

    $('body').keydown(function (event) {
      if ("0".charCodeAt(0) <= event.which && event.which <= "9".charCodeAt(0)) {
        this.appendDigit(String.fromCharCode(event.which));
      }

      if (event.keyCode == 27 || event.keyCode == 8) {
        this.clear();
        event.preventDefault();
      }

    }.bind(this));
  },

  _performUserInput: function (new_card_code) {
    this.setState(React.addons.update(this.state, {
      card_code: { $set: new_card_code }
    }));
    this.fireChangeDebounced();
  },

  _fireChange: function (card_code) {
    this.props.onChange(card_code);
  },

  appendDigit: function (digit) {
    this._performUserInput(this.state.card_code + digit);
  },

  clear: function () {
    this._performUserInput("");
  },

  _fireToggleHelper: function () {
    this.props.onToggleHelper();
  },

  render: function () {
    var digitButton = function (digit) {
      return <StudentPadButton className={this.props.digitsClassName} digit={digit} onClick={this.appendDigit} />;
    }.bind(this)

    return (
      <table className="studentpad">
        <tbody>
          <tr>
            <td colSpan="3" style={{ textAlign: 'center' }}>
              <h1>
                <span style={{ color: '#ccc' }}>SWC/stu/</span>
                <div style={{ width: 3 + 'em', display: 'inline-block', textAlign: 'left' }}>
                  {this.state.card_code}<span className="blink">_</span>
                </div>
              </h1>
            </td>
          </tr>
          <tr>
            {digitButton("1")}
            {digitButton("2")}
            {digitButton("3")}
          </tr>
          <tr>
            {digitButton("4")}
            {digitButton("5")}
            {digitButton("6")}
          </tr>
          <tr>
            {digitButton("7")}
            {digitButton("8")}
            {digitButton("9")}
          </tr>
          <tr>
            <StudentPadButton className="bg-education" onClick={this._fireToggleHelper}>
              <small>
                <i className="glyphicon glyphicon-education" />
              </small>
            </StudentPadButton>
            {digitButton("0")}
            <StudentPadButton onClick={this.clear}>
              <small>
                <i className="glyphicon glyphicon-remove-sign" />
              </small>
            </StudentPadButton>
          </tr>
        </tbody>
      </table>
    );
  }
});

var StudentPadButton = React.createClass({
  click: function () {
    this.props.onClick(this.props.digit);
  },

  render: function () {
    return (
      <td>
        <button onClick={this.click} className={"btn btn-default " + this.props.className}>{this.props.children || this.props.digit}</button>
      </td>
    );
  }
});
