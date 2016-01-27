FROM ruby:2.1-onbuild
ADD server.rb /
EXPOSE 4567
CMD ["ruby", "/server.rb"]
