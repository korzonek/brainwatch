var target = $('#<%= @answer.present? ? "answer-#{@answer.id}": "question" %>');
target.find('.vote').html('<%= @votable.total_votes%>');
