module Sawyer
  # this is need because the sawyer resources that are returned from octokit do
  # not contain the contents of the gists. This is not very elegant since we
  # have to make another request. I am lazy.
  class Resource

    def content
      contents = files.to_a.map do |gist|
        Net::HTTP.get(URI(gist[1][:raw_url]))
      end
      contents.length == 1 ? contents[0] : files.to_h.keys.zip(contents).to_h
    end

    def gist_filename(index=0)
      files.to_h.keys[index].to_s
    end

  end
end
