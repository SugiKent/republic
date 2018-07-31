module StatusHelper
  # レビュー数ランキングにおいて順位を返す
  # 引数はあるUserのResult数
  def set_rank(results_count)
    return User.count if results_count == 0

    # [[レビュー数,ユーザー数],・・・]
    rank_list = Result.group(:user_id).count.sort { |(_k1, v1), (_k2, v2)| v2 <=> v1 }
    sorted_hash = Hash[rank_list]

    # {レビュー数 => そのレビュー数のユーザーの数,・・・}
    counted_rank = sorted_hash.values.each_with_object(Hash.new(0)) { |a, hash| hash[a] += 1; }

    rank = 0
    counted_rank.each do |k, v|
      rank += v
      next if k != results_count
      break
    end

    rank
  end
end
