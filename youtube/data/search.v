import json
import net.http
import time

struct SearchOptions {
	filters SearchOptions_Filters // Can only use one.
	channel_id string
	channel_type string // Acceptable values are: `any`, `show`
	content_type string // Acceptable values are: `channel`, `playlist`, `video`
	event_type string // Acceptable values are: `completed`, `live`, `upcoming`
	location string
	location_radius string // Must end in: `m`, `km`, `ft`, or `mi`
	max_results u16 // Cannot exceed 50. Cannot be less than 1.
	onbehalfof_contentowner string
	order string // Acceptable values are: `date`, `rating`, `relevance`, `title`, `videoCount`, `viewCount`
	page_token string
	published_after string // Must be an ISO 8601 date-time value
	published_before string // Must be an ISO 8601 date-time value
	query string
	region_code string // Must be an ISO 3166-1 alpha-2 country code
	relevance_language string // Must be an ISO 639-1 two-letter language code
	safe_search string // Acceptable values are: `moderate`, `none`, `strict`
	topic_id string
	video_caption string // Acceptable values are: `any`, `closedCaption`, `none`
	video_categoryid string // contentType must be video
	video_definition string // Acceptable values are: `any`, `high`, `standard`
	video_dimension string // Acceptable values are: `2d`, `3d`, `any`
	video_duration string // Acceptable values are: `any`, `long`, `medium`, `short`
	video_embeddable string // Acceptable values are: `any`, `true`
	video_license string // Acceptable values are: `any`, `creativeCommon`, `youtube`
	video_syndicated string // Acceptable values are: `any`, `true`
	video_type string // Acceptable values are: `any`, `episode`, `movie`
}
struct SearchOptions_Filters {
	for_contentowner bool // None of the following other parameters can be set: `videoDefinition`, `videoDimension`, `videoDuration, `videoLicense`, `videoEmbeddable`, `videoSyndicated`, `videoType`.
	for_developer bool
	for_mine bool // The `contentType` parameter's value must be set to video. In addition, none of the following other parameters can be set: `videoDefinition`, `videoDimension`, `videoDuration, `videoLicense`, `videoEmbeddable`, `videoSyndicated`, `videoType`.
	relatedto_videoid string // The `contentType` parameter's value must be set to video. In addition, only the following other parameters can be set: `part`, `maxResults`, `pageToken`, `regionCode`, `relevanceLanguage`, `safeSearch`, `fields`, and `contentType` (which must be set to video).
}

struct SearchResponse {
	kind string
	etag string
	nextpage_token string
	prevpage_token string
	page_info SearchResponse_PageInfo
	items map
}
struct SearchResponse_PageInfo {
	total_results int
	results_per_page int
}

// Returns a list of categories that can be associated with YouTube videos. For more information, see https://developers.google.com/youtube/v3/docs/videoCategories/list
pub fn search_list(part string, options SearchOptions) SearchResponse {
	mut url := "https://www.googleapis.com/youtube/v3/videoCategories?part=$part"
	if options.filters != {} {
		// Can only have one filter
		// TODO: prevent usage of more than one
		if options.filters.for_contentowner == true {
			if options.video_definition != "" ||
				options.video_dimension != "" ||
				options.video_duration != "" ||
				options.video_license != "" ||
				options.video_embeddable != "" ||
				options.video_syndicated != "" ||
				options.video_type != "" { return err }
			url += "&forContentOwner=$options.filters.for_contentowner"
		}
		if options.filters.for_developer == true {	url += "&forDeveloper=$options.filters.for_developer" }
		if options.filters.for_mine == true {
			if options.video_definition != "" ||
				options.video_dimension != "" ||
				options.video_duration != "" ||
				options.video_license != "" ||
				options.video_embeddable != "" ||
				options.video_syndicated != "" ||
				options.video_type != "" { return err }
			if options.content_type != "video" { return err }
			url += "&forDeveloper=$options.filters.for_mine"
		}
		if options.filters.relatedto_videoid != "" {
			if options.channel_id != "" ||
				options.channel_type != "" ||
				options.event_type != "" ||
				options.location != "" ||
				options.location_radius != "" ||
				options.onbehalfof_contentowner != "" ||
				options.order != "" ||
				options.published_after != "" ||
				options.published_before != "" ||
				options.query != "" ||
				options.topic_id != "" ||
				options.video_caption != "" ||
				options.video_categoryid != "" ||
				options.video_definition != "" ||
				options.video_dimension != "" ||
				options.video_duration != "" ||
				options.video_embeddable != "" ||
				options.video_license != "" ||
				options.video_syndicated != "" ||
				options.video_type != "" { return err }
			if options.content_type != "video" { return err }
			url += "&forDeveloper=$options.filters.relatedto_videoid"
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
		date := time.parse_iso8601(options.published_after) or { return err }
	}
		date := time.parse_iso8601(options.published_before) or { return err }
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