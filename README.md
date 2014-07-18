# TransForms
[![Gem Version](https://badge.fury.io/rb/trans_forms.svg)](http://badge.fury.io/rb/trans_forms)
[![Build Status](https://travis-ci.org/dannemanne/trans_forms.svg?branch=master)](https://travis-ci.org/dannemanne/trans_forms)
[![Code Climate](https://codeclimate.com/github/dannemanne/trans_forms.png)](https://codeclimate.com/github/dannemanne/trans_forms)
[![Test Coverage](https://codeclimate.com/github/dannemanne/trans_forms/coverage.png)](https://codeclimate.com/github/dannemanne/trans_forms)

TransForms is short for Transactional Forms. I created it mainly because I felt that
the ActiveRecord Models all to often get cluttered with a lot of conditional validations
and processing. As some of my models grew, I noticed that most of the mess was caused
by complex validations and callbacks that were sometimes needed, and other times they
were out of scope and had to be skipped, just to allow the record to be saved. I felt
that there was another layer missing.

By placing some of the logic and validations, that only needs to be processed in certain
scenarios, into dedicated Form Models, the ActiveRecord Models got a lot cleaner. And
in the process I gained more control of the save transaction. And the greatest benefit of
this setup is the ability to easily update multiple records without having to rely on
messy callbacks and exceptions in association validations.

This is the first extract of what I have been using in one of my projects. So far it
is still missing some of the functionality I have in the original (like confirmation
handling when conflicts occur) but the core is there. And more will come as I manage
to detach it from the more specific business logic.

## Installation

Add this line to your application's Gemfile:

    gem 'trans_forms'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trans_forms

## Writing Form Models

Form Models inherit from `TransForms::FormBase` and live in the `app/trans_forms`
directory of your application.

    # app/trans_forms/post_form.rb
    class PostForm < TransForms::FormBase
      # ...
    end

### Generators

To manually generate a Form Model, you can run...

    rails g trans_form PostForm

... to create a `PostForm` Form Model.

### Shared Form Model Methods

You might want to add some default functionality to all your Form Models. The common
practice to accomplish this is to have an application specific model that inherits
from the FormBase. Then you have all of your FormModels inherit from this model instead.

You can generate a default model like this by running:

TODO: Add generator

This will add an `ApplicationTransForm` model...

    # app/trans_forms/application_trans_form.rb
    class ApplicationTransForm < TransForms::FormBase
      # ...
    end

... that you can use in you Form Models:

    class PostForm < ApplicationTransForm
      # ...
    end

Note that by having a model with the exact name `ApplicationTransForm`, the generator
for new Form Models will by default inherit from that model instead of the `TransForm::FormBase`

## Contributing

1. Fork it ( https://github.com/dannemanne/trans_forms/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
