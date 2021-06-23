import json
import net.http
import time

struct ActivitiesOptions {
	filters ActivitiesOptions_Filters
	max_results u16
	page_token string
	published_after string // Must be ISO 8601
	published_before string // Must be ISO 8601 
	region_code string // Must be ISO 3166-1 alpha-2
}

struct ActivitiesOptions_Filters {
	// Can only have one filter
	channel_id string
	channelId string
	mine bool
}

struct ActivitiesResponse {
	kind string
	etag string
	nextpage_token string
	prevpage_token string
	page_info ActivitiesResponse_PageInfo
	items map
}

struct ActivitiesResponse_PageInfo {
	total_results int
	resultsper_page int
}

// Returns a list of channel activity events that match the request criteria. For more information, see https://developers.google.com/youtube/v3/docs/activities/list
pub fn activites_list(part string, options? ActivitiesOptions) ActivitiesResponse {
	mut url := "https://www.googleapis.com/youtube/v3/activites?part=$part"
	if options.filters != {} {
		// Can only have one filter
		if options.filters.channel_id != "" && options.filters.mine == true { return err }
		if options.filters.channel_id != "" { url += "&channelId=$options.filters.channel_id" }
		if options.filters.mine == true { url += "&mine=$options.filters.mine" }
	}  

	if options.max_results != 0 { url += "&maxResults=$options.max_results" }
		date := time.parse_iso8601(options.published_after) or { return err }
	}
		date := time.parse_iso8601(options.published_before) or { return err }
	}
	if(options.regionCode) { url = "$url&regionCode=$options.regionCode" }

	resp := http.get_text(url) or { return err }
	mut body := json.decode(resp) or { return err }
	
	res := body.as_map()
	return res
}

