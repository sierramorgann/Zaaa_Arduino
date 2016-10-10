import processing.serial.*; //import the Serial library
import java.io.UnsupportedEncodingException;
import java.util.Arrays;

static String OAuthConsumerKey = "PByB8ktHzN5lHvP2ps55FIBWF";
static String OAuthConsumerSecret = "YpVUvPHFJQItuw5dRrUlTmI5f5A9M70GpzXUV2QYqJgpzpa8to";
static String AccessToken = "1031448324-ca3wZoOuNKyP3KgJwzXixb8Utfs1f0h8hJDfx7G";
static String AccessTokenSecret = "WgEO5Hird475GZvbR4g5pMUJf5dVEpJaLGNSpstRMungT";

Serial myPort;  //the Serial port object
TwitterFactory twitterFactory;
Twitter twitter;
 
ArrayList<String> tweets = new ArrayList<String>();
int charLength = 141;
char[] ch = new char[charLength]; // store characters to turn into bytes
String[] arrayOfTweets = new String[] {};
byte[] theTweetBytes = new String(ch).getBytes(); //new string to bytes conversion
boolean hasTweetToSend = false; 
String inChar;
boolean firstContact = false;
StringBuilder sb = new StringBuilder();
int by = new String(ch).getBytes().length; // turns tweet string array to bytes THIS IS ALWAYS 141


void setup() {
  size(800, 200); //make our canvas 200 x 200 pixels big
  myPort = new Serial(this, Serial.list()[2], 115200);
  myPort.bufferUntil('\n');
}
    
void serialEvent(Serial myPort) {
  inChar = myPort.readString(); 
     if (myPort.available() >= 0 && inChar != null){
         delay(800);
         connectTwitter();  // inChar is now null
     } else {
        //do something 
     }
}

void draw() { 
  background(0); 
  text("received: " + inChar + tweets, 10,50);
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
        outerloop:
            for (Status t : result.getTweets()){
                   tweets.add(t.getText());
                    for (String s : tweets) // loops through tweet array to just get the text
                    {   sb.append(s); // appends text of tweet to object 
                        sb.append("\n"); // splits the tweet text at newline
                        sb.toString(); 
                        break outerloop; 
                     }
                hasTweetToSend = true;
            }   
      } catch (TwitterException te){
           System.out.println("Error");
      }
      
     theTweetBytes = new String(ch).getBytes();
     myPort.write(theTweetBytes); // writes bytes to Serial port
    
     print(ch[2]);
}   

public static int[] countLetters(char[] ch) {
    // Declare and create an array of 26 int
    int[] counts = new int[140];
    // For each lowercase letter in the array, count it
    for (int i = 0; i < ch.length; i++){
        counts[ch[i]]++;
        println(counts);
    }    
    return counts;
}

 public static void displayCounts(int[] counts) {
    for (int i = 0; i < counts.length; i++) {
    if ((i + 1) % 10 == 0)
    System.out.println(counts[i] + " " + (char)(i));
    else
    System.out.print(counts[i] + " " + (char)(i) + " ");
    }
}// End of void displayCounts(int[])
 