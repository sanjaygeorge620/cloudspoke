/////used for activity History     
    public class projhistory {

    /* Properties of the class */
    public String subject { get; private set; }
    public ID taskID { get; private set; }
    public String communicationSubject   { get; private set; }
    public id name   { get; private set; }
    public string nameContact {get;private set;}
    public id relatedTo   { get; private set; }
    public Boolean task {get; public set; }
    public Date duedate { get; private set; }
    public Id assignedTo        { get; private set; }
    public String assignedToName        { get; private set; }  
    public Datetime lastModifieddt         { get; private set; } 
    
    /* Class constructor */
    public projHistory(id i,string s, string cs, ID n, string nc, ID rt, boolean t,date d, ID a, string an, datetime lm ) {
        taskID                  = i;
        subject                 = s;
        communicationSubject    = cs;
        name                    = n;
        nameContact             = (nc == null) ?null:nc;
        relatedTo               = rt;
        task                    = t;
        duedate                 = d;
        duedt                   = (d == null)?null:d.format();
        assignedTo              = a;
        assignedToName          = an;
        lastModifieddate        =lm.format();
        lastModifieddt          =lm;
    }
    
    
    
    public string lastModifieddate { get; set; }
    public string duedt {get;set;}
    //public string lmmonthyr   { get { return lastModifieddt.format('MMMMM yyyy'); } }
    //public string lmtime      { get { return lastModifieddt.format('h:mm a');} }
    //public string lmdayfmt    { get { return lastModifieddt.format('d - EEEE'); } }
    //public integer lmmonth    { get { return lastModifieddt.month();} }
    //public integer lmyear     { get { return lastModifieddt.year();} }
    //public integer lmday      { get { return lastModifieddt.day();} }
    
}