class WebhooksController < ApplicationController
  def validation
    insta_token = ENV.fetch("INSTAGRAM_VERIFY_TOKEN")
    if insta_token == params["hub.verify_token"]
      return render json: params["hub.challenge"]
    else
      head :forbidden
    end
  end

  def event
    puts params["webhook"]
    event = params["webhook"]
    case event["field"]
    when "comments"
      #conseguir el post del comentario
      comment = event["value"]
      Comment.create(text: comment["text"], instagram_post_id: comment["id"])
    end
    #revisar a cuales subscripciones hay que enviar el aviso
  end
end
