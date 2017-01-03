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
ArrayList<Character> ch = new ArrayList<Character>(); //ARRAY LIST OF CHARS 
int i=0;

void setup() {
  size(800, 200); //make our canvas 200 x 200 pixels big
  myPort = new Serial(this, Serial.list()[2], 115200);
}

void draw() { 
  background(0); 
  text("received: " + tweets, 10,50);
}
    
void serialEvent(Serial myPort) { // THIS IS A LOOP
     if(myPort.available() > 0){ 
       //grab line 
       inChar = myPort.readStringUntil('\n'); // reads "ready" from the arduino
         if(inChar != null) {
           if(inChar.trim().equals("ready")) {
             connectTwitter();
             cleanHouse();
             println("ready");
           } else if(inChar.trim().equals("anotherOne")){
             connectTwitter();
             cleanHouse();
             println("anotherone");
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
                for (String s : tweets) // PUTS TWEETS INTO STRING ARRAY LIST "tweets"
                {   sb.append(s); // appends text of tweet to object 
                    sb.append("\n"); //appends new line to the end of the tweet
                    sb.toString(); // makes that tweet its own string
                    for (int i = 0; i < sb.length(); i++) {
                      char c = sb.charAt(i);
                      ch.add(c);
                    }
                }     
            }
      } catch (TwitterException te){
         System.out.println("Error"); // if try doesn't work
      }
      for (int i = 0; i < ch.size(); i++) {
         myPort.write(ch.get(i));
         print(ch.get(i));
      }
      //println(ch.get(i));
}

void cleanHouse(){
      if(ch.get(ch.size() - 1) == '\n'){
        println("I cleared the tweets");
             tweets.clear();
             ch.clear();
             myPort.clear();
    } 
}