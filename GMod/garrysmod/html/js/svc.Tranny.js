
var languageCache = {};

angular.module( 'tranny', [] )

.directive( 'ngTranny', function ( $parse )
{
	return function( scope, element, attrs )
	{
		var strName = "";

		var update = function()
		{
			if ( !IN_ENGINE )
			{
				$(element).text( strName );
				$(element).attr( "placeholder", strName );
				return;
			}

			var outStr_old = languageCache[ strName ] || language.Update( strName, function( outStr )
			{
				languageCache[ strName ] = outStr;
				$(element).text( outStr );
				$(element).attr( "placeholder", outStr );
			} );

			if ( outStr_old )
			{
				// Compatibility with Awesomium
				languageCache[ strName ] = outStr_old;
				$(element).text( outStr_old );
				$(element).attr( "placeholder", outStr_old );
			}
		}

		scope.$watch( attrs.ngTranny, function( value )
		{
			strName = value;
			update();
		} );

		scope.$on( 'languagechanged', function()
		{
			languageCache = {};
			update();
		} );

	}
} )

.directive( 'ngSeconds', function ( $parse )
{
	return function ( scope, element, attrs )
	{
		var strName = "";

		scope.$watch( attrs.ngSeconds, function ( value )
		{
			if ( value < 60 )
				return $(element).text( Math.floor( value ) + " sec" );

			if ( value < 60 * 60 )
				return $( element ).text( Math.floor( value / 60 ) + " min" );

			if ( value < 60 * 60 * 24 )
				return $( element ).text( Math.floor( value / 60 / 60 ) + " hr" );

			$( element ).text( "a long time" );

		});

	}
} );
