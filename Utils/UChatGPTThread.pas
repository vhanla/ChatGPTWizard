{***************************************************}
{                                                   }
{   This unit contains a worker thread to do        }
{   API calls and some other stuff.                 }
{   Auhtor: Ali Dehbansiahkarbon(adehban@gmail.com) }
{                                                   }
{***************************************************}
unit UChatGPTThread;

interface
uses
<<<<<<< HEAD
  System.Classes, System.SysUtils, Vcl.Dialogs,
  XSuperObject, System.Generics.Collections, Winapi.Messages, Winapi.Windows, UChatGPTSetting;

const
  WM_UPDATE_MESSAGE = WM_USER + 5874;
  WM_PROGRESS_MESSAGE = WM_USER + 5875;
  WM_Animated_MESSAGE = WM_USER + 5876;
=======
  System.Classes, System.SysUtils, IdHTTP, IdSSLOpenSSL, IdComponent, Vcl.Dialogs,
  XSuperObject, System.Generics.Collections, Winapi.Messages, Winapi.Windows,
  UChatGPTSetting, UConsts;
>>>>>>> 0d2880bef98fd5aeb2d3aec4d2b456380fe96caf

type
  TExecutorTrd = class(TThread)
  private
    FHandle: HWND;
    FPrompt: string;
    FMaxToken: Integer;
    FTemperature: Integer;
    FModel: string;
    FApiKey: string;
    FFormattedResponse: TStringList;
    FUrl: string;
    FProxySetting: TProxySetting;
    FAnimated: Boolean;
    FTimeOut: Integer;
  protected
    procedure Execute; override;
  public
    constructor Create(AHandle: HWND; AApiKey, AModel, APrompt, AUrl: string; AMaxToken, ATemperature: Integer;
                       AProxayIsActive: Boolean; AProxyHost: string; AProxyPort: Integer; AProxyUsername: string;
                       AProxyPassword: string; AAnimated: Boolean; ATimeOut: Integer);
    destructor Destroy; override;
  end;

  TRequestJSON = class
  private
    FModel: string;
    FPrompt: string;
    FMax_tokens: Integer;
    FTemperature: Integer;
  public
    property model: string read FModel write FModel;
    property prompt: string read FPrompt write FPrompt;
    property max_tokens: Integer read FMax_tokens write FMax_tokens;
    property temperature: Integer read FTemperature write FTemperature;
  end;

  TChoice = class
  private
    FText: string;
    FIndex: Integer;
    FLogProbs: string;
    FFinish_reason: string;
  published
    property text: string read FText write FText;
    property &index: Integer read FIndex write FIndex;
    property logprobs: string read FLogProbs write FLogProbs;
    property finish_reason: string read FFinish_reason write FFinish_reason;
  end;

  TUsage = class
  private
    FPrompt_Tokens: Integer;
    FCompletion_Tokens: Integer;
    FTotal_Tokens: Integer;
  published
    property prompt_tokens: Integer read FPrompt_Tokens write FPrompt_Tokens;
    property completion_tokens: Integer read FCompletion_Tokens write FCompletion_Tokens;
    property total_tokens: Integer read FTotal_Tokens write FTotal_Tokens;
  end;

  TChatGPTResponse = class
  private
    FId: string;
    FObject: string;
    FCreated: Integer;
    FModel: string;
    FChoices: TObjectList<TChoice>;
    FUsage: TUsage;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property id: string read FId write FId;
    property &object: string read FObject write FObject;
    property created: Integer read FCreated write FCreated;
    property model: string read FModel write FModel;
    property choices: TObjectList<TChoice> read FChoices write FChoices;
    property usage: TUsage read FUsage write FUsage;
  end;
  
  TOpenAIAPI = class
  private
    FAccessToken: string;
    FUrl: string;
    FProxySetting: TProxySetting;
    FTimeOut: Integer;
  public
    constructor Create(const AAccessToken, AUrl: string; AProxySetting: TProxySetting; ATimeOut: Integer);
    function Query(const AModel: string; const APrompt: string; AMaxToken: Integer; Aemperature: Integer): string;
  end;

implementation

<<<<<<< HEAD
uses
  Net.HttpClient, Net.URLClient;

constructor TOpenAIAPI.Create(const AAccessToken, AUrl: string; AProxySetting: TProxySetting);
=======
{ TOpenAIAPI }
constructor TOpenAIAPI.Create(const AAccessToken, AUrl: string; AProxySetting: TProxySetting; ATimeOut: Integer);
>>>>>>> 0d2880bef98fd5aeb2d3aec4d2b456380fe96caf
begin
  inherited Create;
  FAccessToken := AAccessToken;
  FUrl := AUrl;
  FProxySetting := AProxySetting;
  FTimeOut := ATimeOut;
end;

function TOpenAIAPI.Query(const AModel: string; const APrompt: string; AMaxToken: Integer; Aemperature: Integer): string;
var
  LvHttpClient: THTTPClient;
  LvParamStream: TStringStream;
  LvRequestJSON: TRequestJSON;
  LvChatGPTResponse: TChatGPTResponse;
  LvResponse: IHTTPResponse;
  LvResponseStream: TStringStream;
  LvResult: string;
begin
<<<<<<< HEAD
  LvResult := 'No data';
  LvHttpClient := THTTPClient.Create;
  LvResponseStream := TStringStream.Create;
=======
  LvHttpClient := TIdHTTP.Create(nil);
  LvHttpClient.ConnectTimeout := FTimeOut * 1000;
  LvHttpClient.ReadTimeout := (FTimeOut * 1000) * 2;

  if (FProxySetting.Active) and (not LvHttpClient.ProxyParams.ProxyServer.IsEmpty) then
  begin  
    LvHttpClient.ProxyParams.ProxyServer := FProxySetting.ProxyHost;
    LvHttpClient.ProxyParams.ProxyPort := FProxySetting.ProxyPort;
    LvHttpClient.ProxyParams.ProxyUsername := FProxySetting.ProxyUsername;
    LvHttpClient.ProxyParams.ProxyPassword := FProxySetting.ProxyPassword;
  end;    
  
  LvSslIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  LvChatGPTResponse := TChatGPTResponse.Create;
>>>>>>> 0d2880bef98fd5aeb2d3aec4d2b456380fe96caf
  LvRequestJSON := TRequestJSON.Create;
  LvChatGPTResponse := TChatGPTResponse.Create;
  try
    with LvRequestJSON do
    begin
      model := AModel;
      prompt := APrompt;
      max_tokens := AMaxToken;
      temperature := Aemperature;
    end;

    LvParamStream := TStringStream.Create(LvRequestJSON.AsJSON(True), TEncoding.UTF8);
    try
      LvHttpClient.SecureProtocols := [THTTPSecureProtocol.SSL2, THTTPSecureProtocol.SSL3,
              THTTPSecureProtocol.TLS1, THTTPSecureProtocol.TLS11, THTTPSecureProtocol.TLS12, THTTPSecureProtocol.TLS13];
      LvHttpClient.ConnectionTimeout := 3000;
      LvHttpClient.CustomHeaders['Authorization'] := 'Bearer ' + FAccessToken;
      LvHttpClient.ContentType := 'application/json';
      LvHttpClient.AcceptEncoding := 'deflate, gzip;q=1.0, *;q=0.5';

      if (FProxySetting.Active) and (not LvHttpClient.ProxySettings.Host.IsEmpty) then
      begin
        LvHttpClient.ProxySettings := TProxySettings.Create( FProxySetting.ProxyHost,
                            FProxySetting.ProxyPort, FProxySetting.ProxyUsername,
                            FProxySetting.ProxyPassword);
      end;
      LvParamStream.Position := 0;
      LvResponse := LvHttpClient.Post(FUrl, LvParamStream, LvResponseStream);

      if LvResponse.StatusCode = 200 then
      begin
        LvResponseStream.Position := 0;
        try
          if not LvResponseStream.DataString.IsEmpty then
            LvResult := UTF8ToString(LvChatGPTResponse.FromJSON(LvResponseStream.DataString).choices[0].Text.Trim);
        except
          on E: Exception do
            LvResult := '1: ' + E.Message;
        end;
      end
      else
        LvResult := 'Error Code: ' + LvResponse.StatusText;
    finally
      LvParamStream.Free;
    end;
  except
    on E: Exception do
      LvResult := '2: '+ E.Message;
  end;
  LvResponseStream.Free;
  FreeAndNil(LvHttpClient);
  LvRequestJSON.Free;
  LvChatGPTResponse.Free;

  Result := LvResult;
end;


{ TChatGPTResponse }

constructor TChatGPTResponse.Create;
begin
  inherited Create;
  FChoices := TObjectList<TChoice>.Create;
  FUsage := Tusage.Create;
end;

destructor TChatGPTResponse.Destroy;
begin
  FChoices.Free;
  FUsage.Free;
  inherited;
end;

{ TExecutorTrd }
constructor TExecutorTrd.Create(AHandle: HWND; AApiKey, AModel, APrompt, AUrl: string; AMaxToken, ATemperature: Integer;
                       AProxayIsActive: Boolean; AProxyHost: string; AProxyPort: Integer; AProxyUsername: string;
                       AProxyPassword: string; AAnimated: Boolean; ATimeOut: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FFormattedResponse := TStringList.Create;
  FApiKey := AApiKey;
  FModel := AModel;
  FPrompt := APrompt;
  FMaxToken := AMaxToken;
  FTemperature := ATemperature;
  FHandle := AHandle;
  FUrl := AUrl;
  FAnimated := AAnimated;
  FTimeOut := ATimeOut;
  FProxySetting := TProxySetting.Create;
  with FProxySetting do
  begin
    Active := AProxayIsActive;
    ProxyHost := AProxyHost;
    ProxyPort := AProxyPort;
    ProxyUsername := AProxyUsername;
    ProxyPassword := AProxyPassword;
  end;
  PostMessage(FHandle, WM_PROGRESS_MESSAGE, 1, 0);
end;

destructor TExecutorTrd.Destroy;
begin
  FFormattedResponse.Free;
  FProxySetting.Free;
  PostMessage(FHandle, WM_PROGRESS_MESSAGE, 0, 0);
  inherited;
end;

procedure TExecutorTrd.Execute;
var
  LvAPI: TOpenAIAPI;
  LvResult: string;
  I: Integer;
{=================================================}
{  Lparams meaning:                               }
{  0 = sending whole string in one message        }
{  1 = sending character by character(animated)   }
{  2 = Finished the task.                         }
{  3 = Exceptions.                                }
{=================================================}
begin
  inherited;
  LvAPI := TOpenAIAPI.Create(FApiKey, FUrl, FProxySetting, FTimeOut);
  try
    try
      if not Terminated then
        LvResult := LvAPI.Query(FModel, FPrompt, FMaxToken, FTemperature).Trim;

      if (not Terminated) and (not LvResult.IsEmpty) then
      begin
        if FAnimated then
        begin
          for I := 0 to Pred(LvResult.Length) do
          begin
            if not Terminated then
            begin
              Sleep(1);
              if not Terminated then
                SendMessage(FHandle, WM_UPDATE_MESSAGE, Integer(LvResult[I]), 1);
            end;
          end;
          SendMessage(FHandle, WM_UPDATE_MESSAGE, 0, 2);
        end
        else
        begin
          SendMessageW(FHandle, WM_UPDATE_MESSAGE, Integer(LvResult), 0);
          SendMessage(FHandle, WM_UPDATE_MESSAGE, 0, 2);
        end;
      end;
    except on E: Exception do
      begin
        Sleep(10);
        SendMessageW(FHandle, WM_UPDATE_MESSAGE, Integer(E.Message), 3);
        Terminate;
      end;
    end;
  finally
    LvAPI.Free;
  end;
end;

end.
