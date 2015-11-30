var CashieDashboard = React.createClass({
  getInitialState: function() {
    return { courses: [], page: null };
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

  toggleStudentsSearch: function(event) {
    if (this.state.page == "students_search") {
      this.setState(React.addons.update(this.state, {
        page : { $set : null },
      }));
    } else {
      this.setState(React.addons.update(this.state, {
        page : { $set : "students_search" },
      }));
    }

    event.preventDefault();
  },

  toggleCourse: function(course) {
    if (_.get(this.state.page, "course", null) == course) {
      this.setState(React.addons.update(this.state, {
        page : { $set : null },
      }));
    } else {
      this.setState(React.addons.update(this.state, {
        page : { $set : { course: course } },
      }));
    }
  },

  render: function() {
    return (
      <div className="row">
        <Timer onTimer={this.onTimer} interval={12000} />
        <div className="col-md-2">
          <div className="list-group">
            <a href="#" onClick={this.toggleStudentsSearch} className={classNames("list-group-item", {active: this.state.page == "students_search"})}>
              <h4><i className="glyphicon glyphicon-search" /> Alumnos</h4>
            </a>

            {this.state.courses.map(function(item){
              var selected = _.get(this.state.page, "course", null) == item;
              
              var iconClassNames = classNames("glyphicon", {
                "glyphicon-time": !item.started,
                "glyphicon-bell": item.started && item.attention_required,
                "missing-payment": !selected && item.started && item.attention_required,
                "glyphicon-ok": item.started && !item.attention_required,
              })

              var titleClassName = classNames({"missing-payment": !selected && item.started && item.attention_required})

              var onClick = function(event) { this.toggleCourse(item); event.preventDefault(); }.bind(this);
              return (
                <a href="#" onClick={onClick} className={classNames("list-group-item", {active: selected})} key={item.course}>
                  <h4 className={titleClassName}>
                    {item.room_name.split('-').map(function(part, index){
                    return (<span key={index}>{part}<br/></span>);
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
        <div className="col-md-10">
        {(function(){
          if (this.state.page == null) return;

          if (this.state.page == "students_search") {
            return <CashierStudentSearch {...this.props} />;
          } else if (_.get(this.state.page, "course", null) != null) {
            var course = this.state.page.course;
            if (!course.started) {
              return (<div>
                <h1>{course.room_name}</h1>
                <p>Aún no hay datos</p>
              </div>);
            } else {
              return <CashierCourseDetails {...this.props} course={course.course} />;
            }
          }
        }.bind(this))()}
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
