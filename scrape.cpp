//compile with -lcurl
//this is a mess, use getSchedule.py 

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <tuple>
#include <curl/curl.h> //your directory may be different
using namespace std;

string data; //will hold the url's contents

size_t writeCallback(char* buf, size_t size, size_t nmemb, void* up)
{ //callback must have this declaration
    //buf is a pointer to the data that curl has for us
    //size*nmemb is the size of the buffer

    for (int c = 0; c<size*nmemb; c++)
    {
        data.push_back(buf[c]);
    }
    return size*nmemb; //tell curl how many bytes we handled
}

int main()
{
    CURL* curl; //our curl object

    //get url from user
    string url = "http://annarboradulthockey.com/master_sched_league.php?day=";
    cout << "Enter The Date (dd mm yyyy): ";
    int d,m,y;
    cin >> d >> m >> y;
    cout << endl;

    url += to_string(d) + "&month=" + to_string(m) + "&year=" + to_string(y);

    curl_global_init(CURL_GLOBAL_ALL); //pretty obvious
    curl = curl_easy_init();

    curl_easy_setopt(curl, CURLOPT_URL, url.c_str());
    curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, &writeCallback);
    curl_easy_setopt(curl, CURLOPT_VERBOSE, 1L); //tell curl to output its progress

    curl_easy_perform(curl);

    //cout << endl << data << endl;

//data string = sched table raw html - need parsing
    int totalsize = data.length();
    size_t found = data.find("<div id=\"sched\">");

    totalsize -= found;//remove unneeded html before table

    data = data.substr(found, totalsize);

    size_t end = data.find("</div></div>");//end of sched table

    data = data.substr(0, end + 15);//remove html after table

    //cout <<endl << data << endl;

    //filter raw html
    string varsity;
    string olympic;
    string stadium;

    //store vteam, hteam, rink
    vector<tuple<string, string, string>> vec2;

    vector<string> vec;
    int i = 0;

    while(true){

      size_t y = data.find("</a>");
      if(y == string::npos){break;}

      vec.push_back(data.substr(0, y));
      totalsize = data.length();

      data = data.substr(y + 4);

      //cout << vec.at(i) << endl << endl;
      //i++;
    }

    remove("out.txt");
    ofstream f { "out.txt" }; //new file
    fstream file;
    file.open("out.txt");

    for(i = 0; i < vec.size(); i++){
      if(vec.at(i).find("SHOW") != string::npos){
        continue;
      }
      else{
        size_t slt1 = vec.at(i).find("- ");
        size_t elt1 = vec.at(i).find("Visitor");
        size_t slt2 = vec.at(i).find("@&nbsp;");
        size_t elt2 = vec.at(i).find("Home");

        //cout << slt1 << "," << elt1<< endl;

        string s0 = vec.at(i).substr(slt1 + 2, elt1 - slt1 - 4);
        string s1 = vec.at(i).substr(slt2 + 7, elt2 - slt2 - 9);
        string s2 = vec.at(i).substr(vec.at(i).length() - 12);


        //sort the list? yes
        //file << s0 <<endl<<s1<<endl<<s2<<endl<<endl;

        vec2.push_back(make_tuple(s0, s1, s2));
      }
    }

    int o = 0;
    int s = 0;
    int v = 0;
    for(i = 0; i < vec2.size(); i++){
      string vt = get<0>(vec2.at(i));
      string ht = get<1>(vec2.at(i));
      string l = get<2>(vec2.at(i));
      if(l == "Olympic Rink"){
        olympic += vt + "," + ht + "," + l + "\n";
        o++;
      }
      if(l == "Stadium Rink"){
        stadium += vt + "," + ht + "," + l + "\n";
        s++;
      }
      if(l == "Varsity Rink"){
        varsity += vt + "," + ht + "," + l + "\n";
        v++;
      }
    }

    file << o << endl << s << endl << v << endl << olympic << endl << stadium << endl << varsity << endl;


    file.close();

    curl_easy_cleanup(curl);
    curl_global_cleanup();

    return 0;
}
