---
layout: site
---

{% for post in site.posts limit:5 %}
<div class="post">
	<h1><a href="{{ page.url }}">{{ post.title }}</a></h1>
	<div class="meta">
		{% if post.date != null %} 
		<span class="date">{{ post.date | date_to_string }}</span>
		{% endif %}
		<span class="author">{{ post.author }}</span> 
		wrote <span class="wordcount">{{ post.content | number_of_words }} words</span>
	</div>
	<div class="body">{{ post.content }}</div>
</div>
{% endfor %}
