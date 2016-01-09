var CashierStudentSearch = React.createClass({
  render: function() {
    return <StudentSearch {...this.props} />
  }
});

var DebouncedInput = React.createClass({
  getInitialState: function(){
    return { value: '' };
  },

  // debounce: http://stackoverflow.com/a/24679479/30948
  componentWillMount: function() {
    this.fireChangeDebounced = _.debounce(function(){
      this._fireChange.apply(this, [this.state.value]);
    }, 500);
  },

  onChange: function(event) {
    this.setState(React.addons.update(this.state, {
      value: { $set: event.target.value }
    }));
    this.fireChangeDebounced();
  },

  _fireChange: function(value) {
    this.props.onChange(value);
  },

  render: function() {
    var props = _.omit(this.props, "onChange");
    return (<input type="text" {...props} value={this.state.value} onChange={this.onChange} />);
  }
});

var StudentSearch = React.createClass({

  getDefaultProps: function() {
    return {
      onStudentChosen: null
    };
  },

  getInitialState: function(){
    return {
      students: [],
      next_url: null,
      total_count: null,
      new_student: null,
    }
  },

  onSearchChange: function(value) {
    this.setState(React.addons.update(this.state, {
      students: {$set: []},
      next_url: {$set: null},
      total_count: {$set: null},
      new_student: {$set: null},
    }));

    if (value != '') {
      this.appendPage(URI('/cashier/students.json').search({q: value}).toString());
    }
  },

  loadMore: function() {
    this.appendPage(this.state.next_url);
  },

  showNewStudentForm: function(event) {
    this.setState(React.addons.update(this.state, {
      new_student: {$set: {}}, //TODO grab search state and initialize student
    }));
    event.preventDefault();
  },

  appendPage: function(url) {
    $.ajax({
      method: 'GET',
      url: url,
      success: function(data) {
        this.setState(React.addons.update(this.state, {
          students: {$push: data.items},
          next_url: {$set: data.next_url},
          total_count: {$set: data.total_count}
        }));
      }.bind(this)
    });
  },

  newStudentCreate: function(student) {
    this.setState(React.addons.update(this.state, {
      students: {$push: [student]},
      new_student: {$set: null},
    }));

    if (this.props.onStudentChosen) {
      this.props.onStudentChosen(student);
    }
  },

  newStudentCancel: function() {
    this.setState(React.addons.update(this.state, {
      new_student: {$set: null},
    }));
  },

  render: function() {
    return (
      <div className="form">
        <DebouncedInput autoFocus="true" className="form-control input-lg" placeholder="Buscar alumno" onChange={this.onSearchChange} />

        <br/>

        {(function(){
          switch (this.state.total_count) {
            case null: return null;
            case 1:    return <p>{this.state.total_count} alumno encontrado</p>;
            default:   return <p>{this.state.total_count} alumnos encontrados</p>;
          }
        }.bind(this))()}

        {this.state.students.map(function(student){
          return <StudentRecord key={student.id} student={student} config={this.props.config} onStudentChosen={this.props.onStudentChosen} />;
        }.bind(this))}

        <p>
        {(function(){
          if (this.state.next_url != null) {
            return <a className="form-control btn btn-default" onClick={this.loadMore}>Cargar más alumnos</a>;
          }
        }.bind(this))()}
        </p>

        {(function(){
          if (this.state.new_student == null) {
            var newStudentLink = (<a href="#" className="btn btn-default" role="button" onClick={this.showNewStudentForm}>Crear nuevo</a>);

            if (this.state.total_count == 0) {
              return (<div>
                <hr/>
                  <h4>Alumno no encontrado</h4>
                  <p>
                    {newStudentLink}
                  </p>
              </div>);
            } else if (this.state.total_count != null) {
              return (<div><hr/> {newStudentLink}</div>);
            } else {
              return newStudentLink;
            }
          } else {
            return (
              <NewStudentForm student={this.state.new_student} onCancel={this.newStudentCancel} onCreate={this.newStudentCreate} config={this.props.config}/>
            );
          }

        }.bind(this))()}

      </div>
    );
  }
});

var StudentPaymentControls = React.createClass({
  paySingleClass: function(pending_class_item) {
    var student = this.props.student;
    var message = "Recibir " + this.props.config.single_class_price + " de " + student.first_name + " " + student.last_name + " en concepto de " + pending_class_item.course;
    this.refs.dialog.confirm(message).then(function(){
      $.ajax({
        method: 'POST',
        url: '/cashier/students/' + student.id + '/single_class_payment/' + pending_class_item.id,
        success: function(data) {
          if (data.success != 'error') {
            this.props.onStudentUpdated(data.student);
          }
        }.bind(this)
      });
    }.bind(this));
  },

  payPack: function(pack) {
    var student = this.props.student;
    var message = "Recibir Pack " + pack.description + " de " + student.first_name + " " + student.last_name;
    this.refs.dialog.confirm(message).then(function(){
      $.ajax({
        method: 'POST',
        url: '/cashier/students/' + student.id + '/pack_payment/',
        data: { code: pack.code },
        success: function(data) {
          if (data.success != 'error') {
            this.props.onStudentUpdated(data.student);
          }
        }.bind(this)
      });
    }.bind(this));
  },

  render: function() {
    var student = this.props.student;

    return (
      <div className="row">
        <ConfirmDialog ref="dialog" />
        <div className="col-md-6">
          {(function(){
            if (student.today_pending_classes.length > 0) {
              return (<div>
                <p>Recibir pago de clases de hoy individualmente</p>
                <div className="btn-group">
                {student.today_pending_classes.map(function(item){
                  var onClick = function() { this.paySingleClass(item); }.bind(this);
                  return <button key={item.id} className="btn btn-default" onClick={onClick}>{item.course}</button>;
                }.bind(this))}
                </div>
              </div>);
            }
          }.bind(this))()}
        </div>
        <div className="col-md-6">
          <p>Recibir pago de pack</p>

          <ButtonDropdown title="Elegir pack">
            {this.props.config.payment_plans.map(function(item){
              var onClick = function(event) { this.payPack(item); event.preventDefault(); }.bind(this);
              return <li key={item.price}><a href="#" onClick={onClick}>{item.description}</a></li>;
            }.bind(this))}
          </ButtonDropdown>
        </div>
      </div>
    );
  }
});

var StudentRecord = React.createClass({
  getInitialState: function() {
    return { student : this.props.student };
  },

  studentUpdated: function(student) {
    this.setState(React.addons.update(this.state, {
      student : { $set : student},
    }));
  },

  componentWillReceiveProps: function(nextProps) {
    this.setState(React.addons.update(this.state, {
      student : { $set : nextProps.student},
    }));
  },

  pickStudent: function() {
    this.props.onStudentChosen(this.state.student);
  },

  render: function() {
    var student = this.state.student;

    return (
      <div>
        <hr />
        <div className="row">
          <div className="col-md-4">
            <h4>
              <a href={"/cashier/students/" + student.id} target="_blank">
                {student.first_name}&nbsp;{student.last_name} <small><i className="glyphicon glyphicon-new-window" /></small>
              </a>
            </h4>
            <div className="card_code">{student.card_code}</div>
            <p>{student.email}</p>

            {(function(){
              if (student.available_courses > 0) {
                return (<p>
                  <span className="glyphicon glyphicon-ok" />&nbsp;
                  dispone de <b>{student.available_courses}</b> clases abonadas
                </p>);
              }
            }.bind(this))()}

            {(function(){
              if (student.pending_payments.total > 0) {
                return (<p className="missing-payment">
                  <span className="glyphicon glyphicon-exclamation-sign" />&nbsp;
                  debe <b>{student.pending_payments.this_month}</b> clases este mes. <b>{student.pending_payments.total}</b> en total
                </p>);
              }
            }.bind(this))()}
          </div>
          <div className="col-md-8">
            {(function(){
              if (this.props.onStudentChosen == null) {
                return <StudentPaymentControls student={student} config={this.props.config} onStudentUpdated={this.studentUpdated} />;
              } else {
                return (<div className="row">
                  <div className="col-md-offset-9 col-md-2">
                    <button className="btn btn-default" onClick={this.pickStudent}>Elegir</button>
                  </div>
                </div>);
              }
            }.bind(this))()}
          </div>
        </div>
      </div>
    );
  }
});

var NewStudentForm = React.createClass({
  getInitialState: function(){
    return { student: this.props.student };
  },

  _onStudentPropChange: function(prop, value) {
    this.setState(React.addons.update(this.state, {
      student: {[prop]: {$set: value}}
    }));
  },

  onCreate: function() {
    $.ajax({
      url: '/cashier/students',
      method: 'POST',
      data: {student: this.state.student},
      success: function(data) {
        if (data.status == 'error') {
          this.setState(React.addons.update(this.state, {
            student: {$set: data.student}
          }));
        } else {
          this.props.onCreate(data.student);
        }
      }.bind(this)
    })
  },

  render: function() {
    var studentBind = function(prop) {
      return {
        value: this.state.student[prop],
        errors: _.get(this.state.student, ['errors', prop], null),
        onChange: function(event) {
          this._onStudentPropChange(prop, event.target.value);
        }.bind(this)
      }
    }.bind(this);

    // TODO add known by
    return (
    <div className="form-horizontal">
      <h3>Nuevo alumno</h3>

      <StudentInputField label="Nombre" type="text" {...studentBind('first_name')} />
      <StudentInputField label="Apellido" type="text" {...studentBind('last_name')}/>
      <StudentInputField label="Email" type="email" {...studentBind('email')} />
      <StudentInputField label="Tarjeta" type="text" {...studentBind('card_code')} hint={"En caso de completar, recuerde cobrar los " + this.props.config.new_card_fee} />

      <div className="form-group">
        <label htmlFor="known_by" className="col-sm-2 control-label">Nos conoció por</label>
        <div className="col-sm-10">
          <select className="form-control" value={this.state.student.known_by} onChange={function(event) {
            this._onStudentPropChange('known_by', event.target.value);
          }.bind(this)}>
            <option value="">(elija una opción)</option>
            <option value="facebook">Facebook</option>
            <option value="google">Google</option>
            <option value="friends">Amigos</option>
            <option value="already_known">Ya la conocía por la escena</option>
          </select>
        </div>
      </div>

      <button type="submit" className="btn btn-primary" onClick={this.onCreate}>Crear alumno</button>
      <button type="button" className="btn btn-link" onClick={this.props.onCancel}>Cancelar</button>
    </div>
    );
  }
});

var StudentInputField = React.createClass({
  render: function() {
    var {label, errors, hint, ...inputProps} = this.props;
    var hasErrors = errors != null;

    return (
      <div className={classNames("form-group", {'has-error has-feedback': hasErrors})}>
        <label htmlFor="email" className="col-sm-2 control-label">{label}</label>
        <div className="col-sm-10">
          <input {...inputProps} className="form-control" placeholder={label} />
          {(function(){
            if (hasErrors) {
              return (
                <span className="glyphicon glyphicon-remove form-control-feedback"></span>
              );
            }
          }.bind(this))()}

          {(function(){
            if (hint) {
              return <span className="help-block">{hint}</span>;
            }
          }.bind(this))()}

          {(function(){
            if (hasErrors) {
              return (
                <span className="help-block">{errors.join(', ')}</span>
              );
            }
          }.bind(this))()}
        </div>
      </div>
    );
  }
});
