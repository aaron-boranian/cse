require_relative "slug"
require 'yaml'

module SectionIndex
  # (Array FilePath) -> (Map Tag File)
  Generate = lambda do |manifest|
    idx = {}
    n_ = 0
    m_ = 0
    manifest.each do |path|
      n_ += 1
      bn = File.basename(path, '.md') + ".html"
      content = File.read(path)
      content.lines.map(&:chomp).each do |line|
        if line =~ /^#+\s+(.*)$/
          m_ += 1
          m = line.match(/^#+\s+(.*)$/)
          slug = "#" + Slug::Slugify[m[1]]
          idx[slug] = bn unless idx.include?(slug)
        end
      end
    end
    #puts("Processed #{n_} files, #{m_} sections")
    idx
  end
end

if false
  THIS_DIR = File.expand_path(File.dirname(__FILE__))
  File.write(
    "section-index.yaml",
    SectionIndex::Generate[
      Dir[File.expand_path("../src/*.md", THIS_DIR)] +
      Dir[File.expand_path("../src/records/*.md", THIS_DIR)]
    ].to_yaml
  )
end
