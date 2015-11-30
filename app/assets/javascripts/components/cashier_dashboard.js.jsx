var CashieDashboard = React.createClass({
  getInitialState: function() {
    return { courses: [] };
  },

  onTimer: function() {
    $.ajax({
      url: '/cashier/status',
      method: 'GET',
      success: function(data) {
        this.setState(React.addons.update(this.state, {
          courses : { $set : data.courses },
        }));
      }.bind(this)
    })
  },

  render: function() {
    return (
      <div className="row">
        <Timer onTimer={this.onTimer} interval={12000} />
        <div className="col-md-2">
          <div className="list-group">
            <a href="#"className="list-group-item">
              <h4><i className="glyphicon glyphicon-search" /> Alumnos</h4>
            </a>

            {this.state.courses.map(function(item){
              iconClassNames = classNames("glyphicon", {
                "glyphicon-time": !item.started,
                "glyphicon-bell missing-payment": item.started && item.attention_required,
                "glyphicon-ok": item.started && !item.attention_required,
              })

              titleClassName = classNames({"missing-payment": item.started && item.attention_required})

              return (
                <a href="#" className="list-group-item" key={item.course}>
                  <h4 className={titleClassName}>
                    {item.room_name.split('-').map(function(part){
                    return (<span>{part}<br/></span>);
                  }.bind(this))}</h4>
                  <small>
                    {item.start_time}
                  </small>
                  <br/>
                  <small>
                    <i className={iconClassNames} />&nbsp;
                    {(function(){
                      if (item.started) {
                        return <span><i className="glyphicon glyphicon-user"/> {item.students_count}</span>;
                      }
                    }.bind(this))()}
                  </small>
                </a>);
            }.bind(this))}
          </div>
        </div>
      </div>
    );
  }
});


var Timer = React.createClass({
  componentWillMount: function() {
    this.props.onTimer();
    window.setInterval(this.props.onTimer, this.props.interval);
  },

  render: function() {
    return <span/>;
  }
});
