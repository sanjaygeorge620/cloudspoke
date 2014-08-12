public class SkipLeadContactTriggerExecution {

    public static boolean skipTriggerExec = false;
    
    public static boolean setSkipExecution(){
        skipTriggerExec = true;
        return skipTriggerExec;
    }
    
    public static boolean resetSkipExecution(){
        skipTriggerExec = false;
        return skipTriggerExec;
    }
}