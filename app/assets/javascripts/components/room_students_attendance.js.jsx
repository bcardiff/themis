var RoomStudentsAttendance = React.createClass({
  getInitialState: function(){
    return { student: null, not_found_alert: false }
  },

  onStudentChange: function(card_code) {
    if (card_code == "") {
      this.setState(React.addons.update(this.state, {
        student: { $set: null },
        not_found_alert: { $set: false }
      }));
      return;
    }

    $.ajax({
      url: "/room/course_log/" + this.props.course_log_id + "/students/search",
      data: { q: card_code },
      success: function(data) {
        this._loadSearchStudentResult(data)
      }.bind(this)
    })
  },

  _loadSearchStudentResult: function(result) {
    this.setState(React.addons.update(this.state, {
      student: { $set: result.student },
      not_found_alert: { $set: result.student == null }
    }));
  },

  render: function() {
    var rightPanel = null;

    if (this.state.student) {
      rightPanel = (<div>
        <h1>{this.state.student.first_name}</h1>
        <h1>{this.state.student.last_name}</h1>
        <h1>{this.state.student.email}</h1>
        <h1>{this.state.student.card_code}</h1>
      </div>);
    } else if (this.state.not_found_alert) {
      rightPanel = (<div>
        <h1>Alumno no encontrado</h1>
      </div>);
    }

    return (<div className="row">
      <div className="col-md-6">
        <StudentPad ref="pad" onChange={this.onStudentChange}/>
      </div>
      <div className="col-md-6">
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
