package main

import (
	"fmt"
	"log"

	"github.com/dghubble/go-twitter/twitter"
	"github.com/dghubble/oauth1"
)

func twitter_string(l location) (tweet_str string) {
	var url_str, address_str string
	if l.url() != "" {
		url_str = fmt.Sprintf(" %v", l.url())
	}
	if l.address() != "" {
		address_str = fmt.Sprintf(" (%v)", l.address())
	}
	return fmt.Sprintf("This week's #CoffeeOutside - %v%v%v, see you there! #yycbike", l.Name, url_str, address_str)
}

func notify_twitter(consumer_key string, consumer_secret string, access_token string, access_token_secret string, tweet_str string) {
	config := oauth1.NewConfig(consumer_key, consumer_secret)
	token := oauth1.NewToken(access_token, access_token_secret)
	httpClient := config.Client(oauth1.NoContext, token)
	client := twitter.NewClient(httpClient)

	tweet, resp, err := client.Statuses.Update(tweet_str, nil)
	log.Printf("tweet: %v resp: %v err: %v", tweet, resp, err)
}
