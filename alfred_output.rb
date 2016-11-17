class AlfredOutput
  attr_reader :output

  def initialize
    @output = "<?xml version=\"1.0\"?>\n"
  end

  def self.build
    builder = new
    builder.items do
      yield(builder)
    end
    builder.output
  end

  def items
    @output << "<items>\n"
    yield(self)
    @output << '</items>'
  end

  def item(item)
    @output << <<-eos
      <item uid=#{item[:uid].to_s.encode(xml: :attr)} arg=#{item[:arg].to_s.encode(xml: :attr)} valid="#{item[:valid] != false}">
        <title>#{item[:title].to_s.encode(xml: :text)}</title>
        <subtitle>#{item[:subtitle].to_s.encode(xml: :text)}</subtitle>
        <icon>#{item[:icon].to_s.encode(xml: :text)}</icon>
      </item>
    eos
  end
end
