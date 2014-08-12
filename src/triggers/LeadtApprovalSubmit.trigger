trigger LeadtApprovalSubmit on Lead (after insert) {

    for (Lead l : trigger.new) {
 
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(l.id);
        Approval.ProcessResult result = Approval.process(app);

    }
}