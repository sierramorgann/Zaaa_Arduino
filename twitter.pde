import processing.serial.*; //import the Serial library
import java.io.UnsupportedEncodingException;
import java.util.Arrays;

Serial myPort;  //the Serial port object
TwitterFactory twitterFactory;
Twitter twitter;

static String OAuthConsumerKey = "PByB8ktHzN5lHvP2ps55FIBWF";
static String OAuthConsumerSecret = "YpVUvPHFJQItuw5dRrUlTmI5f5A9M70GpzXUV2QYqJgpzpa8to";
static String AccessToken = "1031448324-ca3wZoOuNKyP3KgJwzXixb8Utfs1f0h8hJDfx7G";
static String AccessTokenSecret = "WgEO5Hird475GZvbR4g5pMUJf5dVEpJaLGNSpstRMungT";

String inChar; //the string of characters read by the serial port
ArrayList<String> tweets = new ArrayList<String>(); // where tweets are stored
StringBuilder sb = new StringBuilder(); // the text of the tweets to strings 
char[] ch = new char[141]; // stores tweets turned into characters
int i=0;

void setup() {
  size(800, 200); //make our canvas 200 x 200 pixels big
  myPort = new Serial(this, Serial.list()[2], 115200);
  connectTwitter();
}

void draw() { 
  background(0); 
  text("received: " + tweets, 10,50);
}
    
void serialEvent(Serial myPort) { // THIS IS A LOOP
     if(myPort.available() > 0){ 
       //grab line 
       inChar = myPort.readStringUntil('\n'); // reads "here" from the arduino
         if(inChar != null) {
           if(inChar.trim().equals("ready")) {
             println("here");
               myPort.write(ch[i]); // writes bytes to Serial port
               
               if (i < ch[i]-1) {
                  // if not step on
                  i++;
                }
                else {
                  //if we are go back to the begining
                  i=0;
                }
           }   
         }  
 }
}

//Initial connection
void connectTwitter() {
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey(OAuthConsumerKey);
  cb.setOAuthConsumerSecret(OAuthConsumerSecret);
  cb.setOAuthAccessToken(AccessToken);
  cb.setOAuthAccessTokenSecret(AccessTokenSecret);
 
  twitterFactory = new TwitterFactory(cb.build());
  twitter = twitterFactory.getInstance();
 
    try {
      Query query = new Query("pizza");
      query.setCount(1); // sets the number of tweets to return per page, up to a max of 100
      QueryResult result = twitter.search(query); 
            for (Status t : result.getTweets()){
                   tweets.add(t.getText());
                for (String s : tweets) // loops through tweet array to just get the text
                {   sb.append(s); // appends text of tweet to object 
                    sb.append("\n"); //appends new line to the end of the tweet
                    sb.toString(); // makes that tweet its own string 
                    //println(sb);
                }    
         }
      } catch (TwitterException te){
         System.out.println("Error"); // if try doesn't work
     }
    
     for (int i = 0; i < sb.length(); i++) { // loop through the array
         ch[i] = sb.charAt(i); // puts each character into array
     } 
}