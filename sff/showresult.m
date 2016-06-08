function showresult( z, cz, gz)
hFig = figure;

set(hFig, 'Position', [100 100 800 300])


subplot(1,3,1), surf(z), shading flat, colormap jet
set(gca, 'zdir', 'reverse', 'xtick', [], 'ytick', [])
%set(gca, 'xtick', [], 'ytick', [])
axis tight, grid off, box on
zlabel('pixel depth (mm)')
title(sprintf('Conventional, RMS = %.3f', sqrt(mse(z,gz))));

subplot(1,3,2), surf(cz), shading flat, colormap jet
set(gca, 'zdir', 'reverse', 'xtick', [], 'ytick', [])
%set(gca, 'xtick', [], 'ytick', [])
axis tight, grid off, box on
zlabel('pixel depth (mm)')
title(sprintf('Compressive, RMS = %.3f', sqrt(mse(cz,gz))));

subplot(1,3,3), surf(gz), shading flat, colormap jet
set(gca, 'zdir', 'reverse', 'xtick', [], 'ytick', [])
%set(gca, 'xtick', [], 'ytick', [])
axis tight, grid off, box on
zlabel('pixel depth (mm)')
title('Ground Truth')

end

function err = mse(A,B) 
err = sqrt(sum(sum((A - B).^2)));
end