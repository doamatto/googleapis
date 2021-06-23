import json
import net.http
import time

// Returns a list of channel activity events that match the request criteria. For more information, see https://developers.google.com/youtube/v3/docs/activities/list
pub fn activites_list(part string, ?options []{
	filters: {
		// Can only have one filter
		channelId: string,
		mine: bool,
	},
	maxResults: u16,
	pageToken: string,
	// Must be ISO 8601
	publishedAfter: string,
	// Must be ISO 8601
	publishedBefore: string,
	// Must be ISO 3166-1 alpha-2
	regionCode: string,
}) []{
	kind: string,
	etag: string,
	nextPageToken: string,
	prevPageToken: string,
	pageInfo: {
		totalResults: int,
		resultsPerPage: int,
	},
	items: []
} {
	url := "https://www.googleapis.com/youtube/v3/activites?part=$part"
	if (filters != nil) {
		// Can only have one filter
		if (filters.channelId && filters.mine) { return err }
		if (filters.channelId) { url += "&channelId=$filters.channelId" }
		if (filters.mine) { url += "&mine=$filters.mine" }
	}  

	if(options.maxResults) { url += "&maxResults=$options.maxResults" }
	if(options.pageToken) { url += "&pageToken=$options.pageToken" }
	if(options.publishedAfter) {
		date := parse_iso8601(options.publishedAfter) or { return err }
		url += "&publishedAfter=$options.date"
	}
	if(options.publishedBefore) {
		date := parse_iso8601(options.publishedBefore) or { return err }
		url = "&publishedBefore=$options.date"
	}
	if(options.regionCode) { url = "$url&regionCode=$options.regionCode" }

	resp := http.get(url) or { return err }
	body := json.decode(resp.text) or { return err }
	
	res := body.as_map()
	return res
}