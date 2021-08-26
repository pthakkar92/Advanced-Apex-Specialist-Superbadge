/**
 * @name AnnouncementQueueable
 * @description This class posts Chatter Announcements
**/
public class AnnouncementQueueable implements Queueable {

    public List<ConnectApi.AnnouncementInput> toPost;
    
    public AnnouncementQueueable(List<ConnectApi.AnnouncementInput> annList)
    {
        toPost = annList;
    }

    //ToDo: Modify this class to implement the Queueable interface and call the postAnnouncements method
    public void execute(QueueableContext context){
        
        PostAnnouncements(toPost);
    }

    /**
     * @name postAnnouncements
     * @description This method is provided for you to facilitate the Super Badge
    **/
    public static void PostAnnouncements(List<ConnectApi.AnnouncementInput> announcements){
        while ( announcements.size() > 0 ){
            if ( Limits.getDMLStatements() < Limits.getLimitDMLStatements() && !test.isRunningTest() ){
                ConnectApi.AnnouncementInput a = announcements.remove(0);
                ConnectApi.Announcements.postAnnouncement('Internal', a);
            } else {
                break;
            }
        }
        if ( announcements.size() > 0 && !test.isRunningTest() ){
            AnnouncementQueueable q = new AnnouncementQueueable(announcements);
            //q.toPost = announcements;
            system.enqueueJob(q);
            //ToDo: Enqueue the above instance of announcementQueueable
        }
    }

}