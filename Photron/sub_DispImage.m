
if nMode == PDC_COLORTYPE_MONO
    colormap( gray(256) );
%  if(nWidth ~= nWidthMax)
%            A = ones(nWidthMax - nWidth,nHeight);
%            B = [ nBuf ; A ];
%            C = ones(nWidthMax, nHeightMax - nHeight);
%            D = [B C];
%            clear nBuf
%            nBuf= D;
%            image( nBuf'); 
%         else
            image( nBuf');   
%   end 
end

if nMode == PDC_COLORTYPE_COLOR
    nInterleave             = PDC_COLORDATA_INTERLEAVE_RGB;
    sub_SetTransferOption
     if(nWidth ~= nWidthMax)
           A = ones(nWidthMax - nWidth,nHeight,3);
           nBuf = permute(nBuf,[2 3 1]);
           B = [ nBuf ; A ];
           C = ones(nWidthMax, nHeightMax - nHeight);
           D1 = [B(:,:,1)  C];
           D2 = [B(:,:,2) C];
           D3 = [B(:,:,3) C];
           clear nBuf
           nBuf(:,:,1) = D1;
           nBuf(:,:,2) = D2;
           nBuf(:,:,3) = D3;
           image(permute(nBuf,[ 2 1 3 ]));

        else
            image( permute( nBuf, [3 2 1] ) );   
        end 
end

