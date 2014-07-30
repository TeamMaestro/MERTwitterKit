//
//  MERThumbnailManager.m
//  MERThumbnailKit
//
//  Created by Adam Girton on 5/1/14.
//  Copyright (c) 2014 Maestro, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(function(){
    if(!document.getElementById('MERThumbnailKitScript')){
        var sc = document.createElement('script');
        sc.setAttribute('id', 'MERThumbnailKitScript');
        sc.text = (function(){
            var STATE = 'complete',
                _readyStateCompleteURI = 'orgmaestromerthumbnailkit:ready';

            function _onReadyStateChange(e){

                if(e.target.readyState == STATE){
                    document.removeEventListener('readystatechange', _onReadyStateChange);
                    window.location.href = _readyStateCompleteURI;
                }
            }

            document.addEventListener('readystatechange', _onReadyStateChange, false);
        })();
        document.body.appendChild(sc);
    }
})();
