# Enumerableな対象の要素の引数指定したラムダ式の結果が全て真であることを検証します。
RSpec::Matchers.define :be_all do |p|
  match do |items|
    @empty = true if items.empty?
    return false if @empty
    items.all? { |item| p.call(item) }
  end

  failure_message do |items|
    if @empty
      "be_all 対象の要素数は1以上必要です。actual:#{items.inspect}"
    else
      "指定した条件にマッチしない要素があります。ng items:#{items.select { |item| ! p.call(item) }}"
    end
  end
end

# Enumerableな対象の要素が引数指定したラムダ式の結果で昇順ソートされているかを検証します。
RSpec::Matchers.define :be_asc do |p|
  match do |items|
    @empty = true if items.empty? || items.length < 2
    return false if @empty
    @actual = items.map { |item| p.call(item) }
    @expect = @actual.sort
    @expect == @actual
  end

  failure_message do |items|
    if @empty
      "be_asc 対象の要素数は2以上必要です。actual:#{items.inspect}"
    else
      "ソート順が不正です。expected:#{@expect}, actual:#{@actual}"
    end
  end
end

# Enumerableな対象の要素が引数指定したラムダ式の結果で降順ソートされているかを検証します。
RSpec::Matchers.define :be_desc do |p|
  match do |items|
    @empty = true if items.empty? || items.length < 2
    return false if @empty
    @actual = items.map { |item| p.call(item) }
    @expect = @actual.sort { |a, b| b <=> a }
    @expect == @actual
  end

  failure_message do |items|
    if @empty
      "be_desc 対象の要素数は2以上必要です。actual:#{items.inspect}"
    else
      "ソート順が不正です。expected:#{@expect}, actual:#{@actual}"
    end
  end
end
