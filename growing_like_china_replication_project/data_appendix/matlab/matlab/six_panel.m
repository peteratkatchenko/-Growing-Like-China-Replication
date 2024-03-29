% workers savings and assets
clear wealth_F
for ii = 2:age_max
    
    % computing existing workers wealth given the guess of  m_t and rho_t
    y=feval('fun_saving_F_existing',[ii,wealth_pre(ii)]);
            
    % wealth time series for the existing workers with age ii
    for tt = 1:age_max-ii+1
        wealth_F(tt,ii+tt-1)=y(1,ii+tt-1);
        consumption_F(tt,ii+tt-1)=y(2,ii+tt-1);
    end
    clear y
        
end % existing workers

% newly born workers
for tt = 1:time_max
        
    % computing workers wealth given the guess of  m_t and rho_t
    y=feval('fun_saving_F_newly_born',[tt]);

    % wealth time series for the existing enterpreneur with age ii
    for ii = 1:age_max
        wealth_F(tt+ii-1,ii)=y(1,ii);
        consumption_F(tt+ii-1,ii)=y(2,ii);
    end
    clear y
    
end % newly born workers

% demographic structure and others
for t = 1:time_max
    
    % no migration
    N_t(t)=nw_pre;
    
    % total assets of workers and total consumptions
    for i = 1:age_max
        AF(t,i)=n_weight(i)*wealth_F(t,i); 
        CF(t,i)=n_weight(i)*consumption_F(t,i);
        CE(t,i)=e_weight(i)*consumption_E(t,i);
    end
    AF_t(t)=sum(AF(t,:)); % aggregate capital in the E sector
    CF_t(t)=sum(CF(t,:)); % aggregate consumption in the F sector
    CE_t(t)=sum(CE(t,:)); % aggregate consumption in the E sector
    
    % the F sector
    if NE_t(t) < N_t(t)
        KF_t(t)=(alp/(r/(1-ice_t(t))+del))^(1/(1-alp))*(N_t(t)-NE_t(t)); % aggregate capital in the F sector
        YF_t(t)=KF_t(t)^alp*(N_t(t)-NE_t(t))^(1-alp); % aggregate output in the F sector
        NF_t(t)=N_t(t)-NE_t(t); % aggregate workers in the F sector
    else
        KF_t(t)=0; YF_t(t)=0; NF_t(t)=0;
    end

end

% aggregation
Y_t=YF_t+YE_t;
K_t=KF_t+KE_t;
C_t=CF_t+CE_t;
for t = 1:time_max-1
    
    % private employment share
    NE_N_t(t)=NE_t(t)/N_t(t);
    
    % computing investment in the F sector
    IF_t(t)=(1+g_t)*(1+g_n)*KF_t(t+1)-(1-del)*KF_t(t);
    
    % computing investment in the E sector
    IE_t(t)=(1+g_t)*(1+g_n)*KE_t(t+1)-(1-del)*KE_t(t);
    
    % investment rates in the two sector
    if YF_t(t)>0
        IF_Y_t(t)=IF_t(t)/YF_t(t);
    else
        IF_Y_t(t)=0;
    end
    IE_Y_t(t)=IE_t(t)/YE_t(t);
    
    % computing workers savings
    SF_t(t)=(1+g_t)*(1+g_n)*AF_t(t+1)-AF_t(t)+del*KF_t(t);
    if YF_t(t) > 0
        SF_YF_t(t)=SF_t(t)/YF_t(t);
    end

    % computing enterpreneurs savings
    SE_t(t)=(1+g_t)*(1+g_n)*AE_t(t+1)-AE_t(t)+del*KE_t(t);
    SE_YE_t(t)=SE_t(t)/YE_t(t);
    
    % aggregate output per capita
    Y_N_t(t)=Y_t(t)/N_t(t);
    
    % aggregate investment rate
    I_Y_t(t)=(IF_t(t)+IE_t(t))/Y_t(t);
    
    % aggregate saving rate
    S_Y_t(t)=(SF_t(t)+SE_t(t))/Y_t(t);

    % capital output ratio
    K_Y_t(t)=K_t(t)/Y_t(t);
    
    % capital outflows
    FA_Y_t(t)=(AE_t(t)+AF_t(t)-K_t(t))/Y_t(t); % stock
    BoP_Y_t(t)=S_Y_t(t)-I_Y_t(t); % flow
    
    if t > 1
        TFP_t(t)=Y_t(t)/Y_t(t-1)-alp*K_t(t)/K_t(t-1)-(1-alp)*N_t(t)/N_t(t-1);
        YG_t(t)=(Y_t(t)/Y_t(t-1)-1)+g_n+g_t;
    end
    
end

% figures
close all
time_begin=1;
time_end=100; time_max-1;
tt=[time_begin:time_end];

data_sav=[0.375905127
0.407118937
0.417687893
0.418696583
0.40780248
0.410464312
0.403822419
0.38944417
0.377046856
0.386282215
0.404312245
0.432183421
0.45699599
0.48157501
0.501039245
0.51206739
];

data_inv=[0.365907013
0.425514577
0.405060796
0.402900174
0.38812706
0.366991801
0.361881671
0.361607682
0.352842054
0.36494929
0.378603128
0.410289533
0.431546215
0.427396271
0.425903209
0.423250045
];

data_res=[0.038897003
0.033068468
0.088594251
0.09722219
0.117766451
0.1420134
0.138692692
0.140515342
0.138805234
0.161149952
0.196974228
0.244702191
0.314965846
0.355479964
0.383515959
0.441448679
];

data_em_sh=[0.041140261
0.063212681
0.10366673
0.168350106
0.232185343
0.322086332
0.434391151
0.474376982
0.522120471
0.563805401
];

data_SI_Y=[0.009998114
-0.01839564
0.012627097
0.015796409
0.01967542
0.043472511
0.041940748
0.027836488
0.024204802
0.021332925
0.025709117
0.021893888
0.025449774
0.054178739
0.075136036
0.088817345
];

% end of year
end_year=2012;

r_F=r./(1-ice_t);

subplot(3,2,1)
plot([1992:2012],r_F(1:21),'-','color','b','linewidth',2)
% xlabel('year')
title('Panel 1: rate of return in F firms')
axis([1992 end_year 0.0 0.12])
hold off

subplot(3,2,2)
plot([1992:end_year],NE_N_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1998:2007],data_em_sh,'-.','color','r','linewidth',2)
hold on
plot([1992:2007],data_em_sh_agg,':','color','k','linewidth',2)
hold off
xlabel('year')
% legend('model','firm data','aggregate data')
title('Panel 2: E firm employment share')
axis([1992 end_year 0.0 0.801])
hold off

subplot(3,2,3)
plot([1992:end_year],S_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1992:2007],data_sav,'-.','color','r','linewidth',2)
hold off
% xlabel('year')
% legend('model','data')
title('Panel 3: aggregate saving rate')
axis([1992 end_year 0.35 0.601])
hold off

subplot(3,2,4)
plot([1992:end_year],I_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1992:2007],data_inv,'-.','color','r','linewidth',2)
hold off
% xlabel('year')
% legend('model','data')
title('Panel 4: aggregate investment rate')
axis([1992 end_year 0.30 0.45])
hold off

% subplot(3,2,5)
% plot([1992:end_year],BoP_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
% hold on
% plot([1992:2007],data_SI_Y,'-.','color','r','linewidth',2)
% hold off
% xlabel('year')
% % legend('model','data')
% axis([1992 end_year -0.05 0.201])
% title('net export GDP ratio')
% hold off

subplot(3,2,5)
plot([1992:end_year],FA_Y_t(1:end_year-1992+1),'-','color','b','linewidth',2)
hold on
plot([1992:2007],data_res,'-.','color','r','linewidth',2)
hold off
xlabel('year')
% legend('model','data')
title('Panel 5: foreign reserve / GDP')
axis([1992 end_year 0.0 0.75])
hold off

subplot(3,2,6)
plot([1992:end_year],TFP_t(1:end_year-1992+1)+(1-alp)*g_t,'-','color','b','linewidth',2)
xlabel('year')
% legend('model','data')
title('Panel 6: TFP growth rate')
axis([1992 end_year 0.0 0.1])
hold off

print -f1 -r600 -depsc 'six panel'

% save data% save data
r_F_0=r_F;
NE_N_t_0=NE_N_t;
S_Y_t_0=S_Y_t;
I_Y_t_0=I_Y_t;
FA_Y_t_0=FA_Y_t;
TFP_t_0=TFP_t;

save data_0 r_F_0 NE_N_t_0 S_Y_t_0 I_Y_t_0 FA_Y_t_0 TFP_t_0