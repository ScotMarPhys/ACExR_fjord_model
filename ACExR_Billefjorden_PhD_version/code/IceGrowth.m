function [Inew] = IceGrowth(FT, T, H)       

        % Generate Ice Layer. Initial growth equation from Adrian Jenkins 
        
        % Global variables
         global LochData SillData Hypso Bdata Const D E Param
         
        % get temperature difference between layer 1 and the freezing point             
        T_diff = (FT-T);    
        
        % Ice thickness is density of seawater multiplied by 
        % the specific capacity of seawater multiplied by 
        % the temperature difference multiplied by 
        % the layer 1 height divided by
        % the latent heat of fusion of ice multiplied by 
        % the density of ice.
        Inew =  (D.rho(1)*Const.cp  * T_diff * H )/ ...
               (Const.LIce * Const.RhoIce);

end

