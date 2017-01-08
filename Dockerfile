FROM ruby:2.1-onbuild
EXPOSE 80
CMD ["ruby", "server.rb", "-p", "80"]
