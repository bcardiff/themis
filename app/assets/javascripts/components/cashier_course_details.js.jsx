var CashierCourseDetails = React.createClass({
  getInitialState: function() {
    return { course_log: null };
  },

  render: function() {
    return (
      <h1>{this.props.course}</h1>
    );
  }
});
