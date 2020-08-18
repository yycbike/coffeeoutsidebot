package main

import (
	"fmt"
	"log"

	"github.com/dghubble/go-twitter/twitter"
	"github.com/dghubble/oauth1"
	"gopkg.in/ini.v1"
)

type TwitterDispatch struct {
	config_file string
	dispatch    Dispatch
	client      *twitter.Client
}

func (t *TwitterDispatch) generate_client() {
	cfg, err := ini.Load(t.config_file)
	if err != nil {
		log.Fatalf("Fail to read file: %v", err)
	}
	config := oauth1.NewConfig(cfg.Section("twitter").Key("consumer_key").String(), cfg.Section("twitter").Key("consumer_secret").String())
	token := oauth1.NewToken(cfg.Section("twitter").Key("token").String(), cfg.Section("twitter").Key("token_secret").String())
	httpClient := config.Client(oauth1.NoContext, token)
	client := twitter.NewClient(httpClient)
	t.client = client
}

func (t TwitterDispatch) notify() {
	t.generate_client()
	tweet, resp, err := t.client.Statuses.Update(t.twitter_string(), nil)
	log.Printf("tweet: %v resp: %v err: %v", tweet, resp, err)
}

func (t TwitterDispatch) twitter_string() string {
	var url_str, address_str string
	if t.dispatch.location.url() != "" {
		url_str = fmt.Sprintf(" %v", t.dispatch.location.url())
	}
	if t.dispatch.location.address() != "" {
		address_str = fmt.Sprintf(" (%v)", t.dispatch.location.address())
	}
	return fmt.Sprintf("This week's #CoffeeOutside - %v%v%v, see you there! #yycbike", t.dispatch.location.Name, url_str, address_str)
}
