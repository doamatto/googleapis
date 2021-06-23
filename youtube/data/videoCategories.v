import net.http

struct VideoCatsOptions {
	filters VideoCatsOptions_Filters
	hl string
}
struct VideoCatsOptions_Filters {
	id string
	region_code string
}

struct VideoCatsResponse {
	kind string
	etag string
	nextpage_token string
	prevpage_token string
	page_info VideoCatsResponse_PageInfo
	items map
}
struct VideoCatsResponse_PageInfo {
	total_results int
	results_per_page int
}

// Returns a list of categories that can be associated with YouTube videos. For more information, see https://developers.google.com/youtube/v3/docs/videoCategories/list
pub fn videocategories_list(part string, options ?VideoCatsOptions) VideoCatsResponse {
	mut url := "https://www.googleapis.com/youtube/v3/videoCategories?part=$part"
		// Can only have one filter
		if (filters.id && filters.regionCode) { return err }
		if (filters.id) { url += "&id=$filters.id" }
		// TOOD: add check for regionCode
		if options.filters.region_code != "" { url += "&regionCode=$options.filters.region_code" }
	}  

	if(options.hl) { url += "&hl=$options.hl" }

	resp := http.get(url) or { return err }
	body := json.decode(resp.text) or { return err }
	
	res := body.as_map()
	return res

}