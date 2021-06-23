import net.http

struct SearchOptions {
	filters Options_Filters // Can only use one.
	channelId string
	channelType string // Acceptable values are: `any`, `show`
	contentType string // Acceptable values are: `channel`, `playlist`, `video`
	eventType string // Acceptable values are: `completed`, `live`, `upcoming`
	location string
	locationRadius string // Must end in: `m`, `km`, `ft`, or `mi`
	maxResults u16 // Cannot exceed 50. Cannot be less than 1.
	onBehalfOfContentOwner string
	order string // Acceptable values are: `date`, `rating`, `relevance`, `title`, `videoCount`, `viewCount`
	pageToken string
	publishedAfter string // Must be an ISO 8601 date-time value
	publishedBefore string // Must be an ISO 8601 date-time value
	query string
	regionCode string // Must be an ISO 3166-1 alpha-2 country code
	relevanceLanguage string // Must be an ISO 639-1 two-letter language code
	safeSearch string // Acceptable values are: `moderate`, `none`, `strict`
	topicId string
	videoCaption string // Acceptable values are: `any`, `closedCaption`, `none`
	videoCategoryId string // contentType must be video
	videoDefinition string // Acceptable values are: `any`, `high`, `standard`
	videoDimension string // Acceptable values are: `2d`, `3d`, `any`
	videoDuration string // Acceptable values are: `any`, `long`, `medium`, `short`
	videoEmbeddable string // Acceptable values are: `any`, `true`
	videoLicense string // Acceptable values are: `any`, `creativeCommon`, `youtube`
	videoSyndicated string // Acceptable values are: `any`, `true`
	videoType string // Acceptable values are: `any`, `episode`, `movie`
}
struct SearchOptions_Filters {
	forContentOwner bool // None of the following other parameters can be set: `videoDefinition`, `videoDimension`, `videoDuration, `videoLicense`, `videoEmbeddable`, `videoSyndicated`, `videoType`.
	forDeveloper bool
	forMine bool // The `contentType` parameter's value must be set to video. In addition, none of the following other parameters can be set: `videoDefinition`, `videoDimension`, `videoDuration, `videoLicense`, `videoEmbeddable`, `videoSyndicated`, `videoType`.
	relatedToVideoId string // The `contentType` parameter's value must be set to video. In addition, only the following other parameters can be set: `part`, `maxResults`, `pageToken`, `regionCode`, `relevanceLanguage`, `safeSearch`, `fields`, and `contentType` (which must be set to video).
}

struct SearchResponse {
	kind string
	etag string
	nextPageToken string
	prevPageToken string
	pageInfo Response_PageInfo
	items map
}
struct SearchResponse_PageInfo {
	totalResults int
	resultsPerPage int
}

// Returns a list of categories that can be associated with YouTube videos. For more information, see https://developers.google.com/youtube/v3/docs/videoCategories/list
pub fn search_list(part string, options SearchOptions) SearchResponse {
	url := "https://www.googleapis.com/youtube/v3/videoCategories?part=$part"
	if (filters != nil) {
		// Can only have one filter
		// TODO: prevent usage of more than one
		if (filters.forContentOwner) {
			if(
				options.videoDefinition != nil ||
				options.videoDimension != nil ||
				options.videoDuration != nil ||
				options.videoLicense != nil ||
				options.videoEmbeddable != nil ||
				options.videoSyndicated != nil ||
				options.videoType != nil
			) { return err }
			url += "&forContentOwner=$filters.forContentOwner"
		}
		if (filters.forDeveloper) {	url += "&forDeveloper=$filters.forDeveloper" }
		if (filters.forMine) {
			if(
				options.videoDefinition != nil ||
				options.videoDimension != nil ||
				options.videoDuration != nil ||
				options.videoLicense != nil ||
				options.videoEmbeddable != nil ||
				options.videoSyndicated != nil ||
				options.videoType != nil
			) { return err }
			if (options.contentType != "video") { return err }
			url += "&forDeveloper=$filters.forMine"
		}
		if (filters.relatedToVideoId) {
			if(
				options.channelId != nil ||
				options.channelType != nil ||
				options.eventType != nil ||
				options.location != nil ||
				options.locationRadius != nil ||
				options.onBehalfOfContentOwner != nil ||
				options.order != nil ||
				options.publishedAfter != nil ||
				options.publishedBefore != nil ||
				options.query != nil ||
				options.topicId != nil ||
				options.videoCaption != nil ||
				options.videoCategoryId != nil ||
				options.videoDefinition != nil ||
				options.videoDimension != nil ||
				options.videoDuration != nil ||
				options.videoEmbeddable != nil ||
				options.videoLicense != nil ||
				options.videoSyndicated != nil ||
				options.videoType != nil
			) { return err }
			if (options.contentType != "video") { return err }
			url += "&forDeveloper=$filters.relatedToVideoId"
		}
	}  

	if(options.channelId) { url += "&channelId=$options.channelId" }
	if(options.channelType) {
		if (
			options.channelType != "any" ||
			options.channelType != "show"
		) { return err }
		url += "&channelType=$options.channelType"
	}
	if(options.contentType) {
		if(
			options.contentType != "channel" ||
			options.contentType != "playlist" ||
			options.contentType != "video"
		) { return err }
		url += "&contentType=$options.contentType"
	}
	if(options.eventType) {
		if(
			options.eventType != "completed" ||
			options.eventType != "live" ||
			options.eventType != "upcoming"
		) { return err }
		url += "&eventType=$options.eventType"
	}
	if(options.location) { url += "&eventType=$options.location" }
	if(options.locationRadius) {
		if (
			!options.locationRadius.ends_with("m") ||
			!options.locationRadius.ends_with("km") ||
			!options.locationRadius.ends_with("ft") ||
			!options.locationRadius.ends_with("mi")
		) { return err }
		url += "&eventType=$options.locationRadius"
	}
	if(options.maxResults) {
		if (
			options.maxResults < 0 ||
			options.maxResults >= 50
		) { return err }
		url += "&eventType=$options.maxResults"
	} else {
		url += "&eventType=5"
	}
	if(options.onBehalfOfContentOwner) { url += "&onBehalfOfContentOwner=$options.onBehalfOfContentOwner" }
	if(options.order) {
		if (
			options.order != "date" ||
			options.order != "rating" ||
			options.order != "relevance" ||
			options.order != "title" ||
			options.order != "videoCount" ||
			options.order != "viewCount"
		) { return err }
		url += "&order=$options.order"
	}
	if(options.pageToken) { url += "&pageToken=$options.pageToken" }
	if(options.publishedAfter) {
		date := parse_iso8601(options.publishedAfter) or { return err }
		url += "&publishedAfter=$options.date"
	}
	if(options.publishedBefore) {
		date := parse_iso8601(options.publishedBefore) or { return err }
		url = "&publishedBefore=$options.date"
	}
	if(options.query) { url += "&q=$options.query" }
	if(options.regionCode) { url += "&q=$options.regionCode" }
	if(options.relevanceLanguage) { url += "&q=$options.relevanceLanguage" }
	if(options.safeSearch) {
		if(
			options.safeSearch != "moderate" ||
			options.safeSearch != "none" ||
			options.safeSearch != "strict"
		) { return err }
		url += "&safeSearch=$options.safeSearch"
	}
	if(options.topicId) { url += "&topicId=$options.topicId" }
	if(options.videoCaption) {
		if (
			options.videoCaption != "any" ||
			options.videoCaption != "closedCaption" ||
			options.videoCaption != "none"
		) { return err }
		url += "&videoCaption=$options.videoCaption"
	}
	if(options.videoCategoryId) {
		if (
			options.contentType != nil ||
			options.contentType != "video"
		) { return err }
		url += "&videoCategoryId=$options.videoCategoryId"
	}
	if(options.videoDefinition) {
		if (
			options.videoDefinition != "any" ||
			options.videoDefinition != "high" ||
			options.videoDefinition != "standard"
		) { return err }
		url += "&videoDefinition=$options.videoDefinition"
	}
	if(options.videoDimension) {
		if (
			options.videoDimension != "2d" ||
			options.videoDimension != "3d" ||
			options.videoDimension != "any"
		) { return err }
		url += "&videoDimension=$options.videoDimension"
	}
	if(options.videoDuration) {
		if (
			options.videoDuration != "any" ||
			options.videoDuration != "long" ||
			options.videoDuration != "medium" ||
			options.videoDuration != "short"
		) { return err }
		url += "&videoDuration=$options.videoDuration"
	}
	if(options.videoEmbeddable) {
		if (
			options.videoEmbeddable != "any" ||
			options.videoEmbeddable != "true"
		) { return err }
		url += "&videoEmbeddable=$options.videoEmbeddable"
	}
	if(options.videoLicense) {
		if (
			options.videoLicense != "creativeCommon" ||
			options.videoLicense != "youtube" ||
			options.videoLicense != "any"
		) { return err }
		url += "&videoLicense=$options.videoLicense"
	}
	if(options.videoSyndicated) {
		if (
			options.videoSyndicated != "any" ||
			options.videoSyndicated != "true"
		) { return err }
		url += "&videoSyndicated=$options.videoSyndicated"
	}
	if(options.videoType) {
		if(
			options.videoType != "any" ||
			options.videoType != "episode" ||
			options.videoType != "movie"
		) { return err }
		url += "&videoType=$options.videoType"
	}

	resp := http.get(url) or { return err }
	body := json.decode(resp.text) or { return err }
	
	res := body.as_map()
	return res

}