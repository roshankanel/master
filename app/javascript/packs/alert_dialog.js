function alert_dialog(headermsg, message){
  $(`<div class="modal fade" id="alertbox" role="dialog">
      <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
          <div class="modal-header btn-warning">
            <h2 class="modal-title">${headermsg}</h5>
          </div>
          <div class="modal-body" style="padding:10px;">
            <h4 style="padding:10px;">${message}</h4>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
          </div>
        </div>
      </div>
   </div>`).appendTo('body');

   //Trigger the modal
  $("#alertbox").modal({
    backdrop: 'static',
    keyboard: false
  });

  //Remove the modal once it is closed.
  $("#alertbox").on('hidden.bs.modal', function () {
    $("#alertbox").remove();
  });
}
