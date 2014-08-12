public class contributeImageNowController {
   public PageReference contribute() {
      User user = [select id, firstName, lastName, department from User where id = :UserInfo.getUserId()];
      
      PageReference Pg = new PageReference('http://' +  Label.ImageNow_Domain_Prefix +'/imagenowforms/fs?form='+User.Department+' Content&authID='+User.Id+'&authName='+ User.FirstName +' ' + User.LastName +'&authDept=' +User.Department);
      Pg.setRedirect(true);
      return Pg;
   }


}