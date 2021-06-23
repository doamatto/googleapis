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

	if options.channel_id != "" { url += "&channelId=$options.channel_id" }
	if options.channel_type != "" {
		if options.channel_type != "any" || options.channel_type != "show" { return err }
		url += "&channelType=$options.channel_type"
	}
	if options.content_type != "" {
		if options.content_type != "channel" ||
			options.content_type != "playlist" ||
			options.content_type != "video" { return err }
		url += "&contentType=$options.content_type"
	}
	if options.event_type != "" {
		if options.event_type != "completed" ||
			options.event_type != "live" ||
			options.event_type != "upcoming" { return err }
		url += "&eventType=$options.event_type"
	}
	if options.location != "" { url += "&eventType=$options.location" }
	if options.location_radius != "" {
		if !options.location_radius.ends_with("m") ||
			!options.location_radius.ends_with("km") ||
			!options.location_radius.ends_with("ft") ||
			!options.location_radius.ends_with("mi") { return err }
		url += "&eventType=$options.location_radius"
	}
	if options.max_results != 0 {
		if options.max_results < 0 || options.max_results >= 50 { return err }
		url += "&eventType=$options.max_results"
	} else {
		url += "&eventType=5"
	}
	if options.onbehalfof_contentowner != "" { url += "&onBehalfOfContentOwner=$options.onbehalfof_contentowner" }
	if options.order != "" {
		if options.order != "date" ||
			options.order != "rating" ||
			options.order != "relevance" ||
			options.order != "title" ||
			options.order != "videoCount" ||
			options.order != "viewCount" { return err }
		url += "&order=$options.order"
	}
	if options.page_token != "" { url += "&pageToken=$options.page_token" }
	if options.published_after != "" {
		date := time.parse_iso8601(options.published_after) or { return err }
		url += "&publishedAfter=$date"
	}
	if options.published_before != "" {
		date := time.parse_iso8601(options.published_before) or { return err }
		url = "&publishedBefore=$date"
	}
	if options.query != "" { url += "&q=$options.query" }
	if options.region_code != "" { url += "&q=$options.region_code" }
	if options.relevance_language != "" { url += "&q=$options.relevance_language" }
	if options.safe_search != "" {
		if options.safe_search != "moderate" ||
			options.safe_search != "none" ||
			options.safe_search != "strict" { return err }
		url += "&safeSearch=$options.safe_search"
	}
	if options.topic_id != "" { url += "&topicId=$options.topic_id" }
	if options.video_caption != "" {
		if options.video_caption != "any" ||
			options.video_caption != "closedCaption" ||
			options.video_caption != "none" { return err }
		url += "&videoCaption=$options.video_caption"
	}
	if options.video_categoryid != "" {
		if options.video_categoryid != "" || options.video_categoryid != "video" { return err }
		url += "&videoCategoryId=$options.video_categoryid"
	}
	if options.video_definition != "" {
		if options.video_definition != "any" ||
			options.video_definition != "high" ||
			options.video_definition != "standard" { return err }
		url += "&videoDefinition=$options.video_definition"
	}
	if options.video_dimension != "" {
		if options.video_dimension != "2d" ||
			options.video_dimension != "3d" ||
			options.video_dimension != "any" { return err }
		url += "&videoDimension=$options.video_dimension"
	}
	if options.video_duration != "" {
		if options.video_duration != "any" ||
			options.video_duration != "long" ||
			options.video_duration != "medium" ||
			options.video_duration != "short" { return err }
		url += "&videoDuration=$options.video_duration"
	}
	if options.video_embeddable != "" {
		if options.video_embeddable != "any" ||	options.video_embeddable != "true" { return err }
		url += "&videoEmbeddable=$options.video_embeddable"
	}
	if options.video_license != "" {
		if options.video_license != "creativeCommon" ||
			options.video_license != "youtube" ||
			options.video_license != "any" { return err }
		url += "&videoLicense=$options.video_license"
	}
	if options.video_syndicated != "" {
		if options.video_syndicated != "any" ||	options.video_syndicated != "true" { return err }
		url += "&videoSyndicated=$options.video_syndicated"
	}
	if options.video_type != "" {
		if options.video_type != "any" ||
			options.video_type != "episode" ||
			options.video_type != "movie" { return err }
		url += "&videoType=$options.video_type"
	}

	resp := http.get_text(url) or { return err }
	body := json.decode(string, resp) or { return err }
	
	res := body.as_map()
	return res
}