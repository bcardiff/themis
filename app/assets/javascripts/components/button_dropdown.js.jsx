var ButtonDropdown = React.createClass({
  render: function() {
    return (
      <div className="btn-group">
        <button type="button" className="btn btn-default btn-lg dropdown-toggle" data-toggle="dropdown">
          {this.props.title} <span className="caret"></span>
        </button>
        <ul className="dropdown-menu dropdown-menu-right dropdown-menu-lg">
          {this.props.children}
        </ul>
      </div>
    );
  }
});
