var ButtonDropdown = React.createClass({
  render: function() {
    return (
      <div className="btn-group">
        <button type="button" className="btn btn-default dropdown-toggle" data-toggle="dropdown">
          {this.props.title} <span className="caret"></span>
        </button>
        <ul className="dropdown-menu">
          {this.props.children}
        </ul>
      </div>
    );
  }
});
