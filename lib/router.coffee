FlowRouter.route '/',
  action: (params, queryParams) ->
    FlowLayout.render 'layout', {body:'main'}