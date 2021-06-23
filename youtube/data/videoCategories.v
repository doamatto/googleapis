import net.http

// Returns a list of categories that can be associated with YouTube videos. For more information, see https://developers.google.com/youtube/v3/docs/videoCategories/list
pub fn videoCategories_list(part string, options ?[]{
	filters: {
		id: string,
		regionCode: string,
	},
	hl: string,
}) []{
	kind: string,
	etag: string,
	nextPageToken: string,
	prevPageToken: string,
	pageInfo: {
		totalResults: int,
		resultsPerPage: int,
	},
	items: [],
} {
	url := "https://www.googleapis.com/youtube/v3/videoCategories?part=$part"
	if (filters != nil) {
		// Can only have one filter
		if (filters.id && filters.regionCode) { return err }
		if (filters.id) { url += "&id=$filters.id" }
		// TOOD: add check for regionCode
		if (filters.regionCode) { url += "&regionCode=$filters.regionCode" }
	}  

	if(options.hl) { url += "&hl=$options.hl" }

	resp := http.get(url) or { return err }
	body := json.decode(resp.text) or { return err }
	
	res := body.as_map()
	return res

}