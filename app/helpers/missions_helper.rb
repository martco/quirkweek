module MissionsHelper
  def display_time(comment)
    distance_of_time_in_words_to_now(comment.created_at, include_seconds = false)
  end
end
