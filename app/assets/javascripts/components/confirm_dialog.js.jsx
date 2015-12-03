var ConfirmDialog = React.createClass({
  getInitialState: function() {
    return { visible: false }
  },

  confirm: function(message) {
    this.deferred = Q.defer();
    this.setState(React.addons.update(this.state, {
      message: { $set: message },
      visible: { $set: true }
    }));

    return this.deferred.promise
  },

  accept: function() {
    this.hide();
    this.deferred.resolve();
  },

  hide: function() {
    this.setState(React.addons.update(this.state, {
      visible : { $set : false },
    }));
  },

  hideOnOuterClick: function(event) {
    if (ReactDOM.findDOMNode(this) == event.target.parentElement)
      this.hide();
  },

  handleKeyDown: function(event) {
    if (!this.state.visible) return;
    if (event.keyCode == 27) // esc
      this.hide();
  },

  componentDidMount: function() {
    document.addEventListener('keydown', this.handleKeyDown);
  },

  componentWillUnmount: function() {
    document.removeEventListener('keydown', this.handleKeyDown);
  },

  render: function() {
    if (!this.state.visible) return null;

    return (
    <div className="modal-wrapper" onKeyDown={this.handleKeyDown}>
      <div className="modal fade in show" onClick={this.hideOnOuterClick}>
        <div className="modal-dialog">
          <div className="modal-content">
            <div className="modal-header">
              <button type="button" className="close" onClick={this.hide}><span>&times;</span></button>
              <h4 className="modal-title">Confirmar</h4>
            </div>
            <div className="modal-body">
              <p>{this.state.message}</p>
            </div>
            <div className="modal-footer">
              <button type="button" className="btn btn-lg btn-default" onClick={this.hide}>Cancelar</button>
              <button type="button" className="btn btn-lg btn-primary" onClick={this.accept}>Aceptar</button>
            </div>
          </div>
        </div>
      </div>
    </div>);
  }
});
