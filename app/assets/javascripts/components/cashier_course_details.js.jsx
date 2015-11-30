var CashierCourseDetails = React.createClass({
  getInitialState: function() {
    return { course_log: {room_name: null, students: []} };
  },

  componentWillMount: function() {
    $.ajax({
      url: URI('/cashier/students/course').query({course: this.props.course}),
      method: 'GET',
      success: function(data) {
        this.setState(React.addons.update(this.state, {
          course_log : { $set : data },
        }));
      }.bind(this)
    })
  },

  render: function() {
    return (
      <div>
        <h1>{this.state.course_log.room_name}</h1>

        {this.state.course_log.students.map(function(student){
          return <StudentRecord key={student.id} student={student} config={this.props.config} />;
        }.bind(this))}
      </div>
    );
  }
});
