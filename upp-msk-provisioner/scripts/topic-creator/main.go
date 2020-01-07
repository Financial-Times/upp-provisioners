package main

import (
	"flag"
	"log"
	"strings"

	"github.com/Shopify/sarama"
)

// Create all the necessary topics in the Amazon MSK Kafka
// Implements sarama ClusterAdmin functionality (reference https://stackoverflow.com/questions/44094926/creating-kafka-topic-in-sarama)
func main() {
	brokerList := flag.String("b", "localhost:9092,localhost:9093,localhost:9094", "Comma separated list of Kafka brokers")
	flag.Parse()

	brokerAddrs := strings.Split(*brokerList, ",")
	config := sarama.NewConfig()
	config.Version = sarama.V2_2_0_0 // Kafka server version is 2.2
	admin, err := sarama.NewClusterAdmin(brokerAddrs, config)
	if err != nil {
		log.Fatal("Error while creating cluster admin: ", err.Error())
	}
	defer func() { _ = admin.Close() }()

	existingTopics, err := admin.ListTopics()
	if err != nil {
		log.Fatal("Error while getting topics list: ", err.Error())
	}

	newTopics := [...]string{
		// Publishing topics
		"NativeCmsMetadataPublicationEvents",
		"NativeCmsPublicationEvents",
		"PreNativeCmsMetadataPublicationEvents",
		"PreNativeCmsPublicationEvents",
		"SmartlogicConcept",
		// Delivery only topics
		"CmsPublicationEvents",
		"CombinedPostPublicationEvents",
		"ConceptAnnotations",
		"ConceptSuggestions",
		"PostConceptAnnotations",
		"PostConceptSuggestions",
		"PostPublicationEvents",
	}
	for _, topic := range newTopics {
		if _, ok := existingTopics[topic]; ok {
			log.Printf(`Topic "%s" already exists, skipping.`, topic)
			continue
		}

		err = admin.CreateTopic(topic, &sarama.TopicDetail{
			NumPartitions:     1,
			ReplicationFactor: 3,
		}, false)
		if err != nil {
			log.Fatal("Error while creating topic: ", err.Error())
		}
	}

	log.Println("Topics created successfully.")
	//	log.Println("Sleeping 5 seconds to ensure replication to all brokers.")
	//	time.Sleep(5 * time.Second)
	//
	//	for _, topic := range newTopics {
	//		err = admin.DeleteTopic(topic)
	//		if err != nil {
	//			log.Fatal("Error while deleting topic: ", err.Error())
	//		}
	//	}
	//	log.Println("Topics deleted successfully.")
}
