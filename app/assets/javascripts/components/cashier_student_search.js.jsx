var CashierStudentSearch = React.createClass({
  render: function() {
    return <StudentSearch />
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
  getInitialState: function(){
    return {
      students: [],
      next_url: null,
      total_count: null,
    }
  },

  onSearchChange: function(value) {
    this.setState(React.addons.update(this.state, {
      students: {$set: []},
      next_url: {$set: null},
      total_count: {$set: null},
    }));

    if (value != '') {
      this.appendPage(URI('/cashier/students.json').search({q: value}).toString());
    }
  },

  loadMore: function() {
    this.appendPage(this.state.next_url);
  },

  appendPage: function(url) {
    $.ajax({
      method: 'GET',
      url: url,
      success: function(data) {
        console.log(data.items);
        this.setState(React.addons.update(this.state, {
          students: {$push: data.items},
          next_url: {$set: data.next_url},
          total_count: {$set: data.total_count}
        }));
      }.bind(this)
    });
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
          return (<div className="thumbnail" key={student.id}>
            <div className="caption">
              <div className="card_code">{student.card_code}</div>
              <h4>{student.first_name}&nbsp;{student.last_name}</h4>
              <p>{student.email}</p>
              <p>
                <a href={"/cashier/students/" + student.id} className="btn btn-default" role="button">Ir a ficha</a>
              </p>
            </div>
          </div>);
        }.bind(this))}

        <p>
        {(function(){
          if (this.state.next_url != null) {
            return <a className="form-control btn btn-default" onClick={this.loadMore}>Cargar más alumnos</a>;
          }
        }.bind(this))()}
        </p>

        {(function(){
          var newStudentLink = (<a href="#" className="btn btn-default" role="button">Crear nuevo</a>);

          if (this.state.total_count == null) {
            return newStudentLink;
          }

          if (this.state.total_count == 0) {
            return (<div className="thumbnail alert-danger">
              <div className="caption">
                <h4>Alumno no encontrado</h4>
                <p>
                  {newStudentLink}
                </p>
              </div>
            </div>);
          }
        }.bind(this))()}

      </div>
    );
  }
});
